create or replace package body utility_invoice_payments as

  /* =====================================================
     ID generator
     ===================================================== */
    function gen_payment_id return varchar2 is
    begin
        return 'PAY-'
               || to_char(sysdate, 'YYYYMMDD')
               || '-'
               || substr(
            replace(
                sys_guid(), '-'
            ),
            1,
            8
        );
    end gen_payment_id;

  /* =====================================================
     Helpers
     ===================================================== */
    function nvl_rate (
        p_rate number
    ) return number is
    begin
        return
            case
                when p_rate is null
                     or p_rate <= 0 then
                    1
                else
                    p_rate
            end;
    end;

  /* =====================================================
     Paid Amount in invoice currency
     ===================================================== */
    function get_paid_amount (
        p_invoice_id in invoices.invoice_id%type
    ) return number is
        v_paid number := 0;
    begin
        select
            nvl(
                sum(amount_in_inv_currency),
                0
            )
        into v_paid
        from
            invoice_payments
        where
                invoice_id = p_invoice_id
            and payment_status = 'POSTED';

        return v_paid;
    end get_paid_amount;

  /* =====================================================
     Balance = grand_total - paid
     ===================================================== */
    function get_balance_amount (
        p_invoice_id in invoices.invoice_id%type
    ) return number is
        v_total   number := 0;
        v_paid    number := 0;
        v_balance number := 0;
    begin
        select
            grand_total
        into v_total
        from
            invoices
        where
            invoice_id = p_invoice_id;

        v_paid := get_paid_amount(p_invoice_id);
        v_balance := round(v_total - v_paid, 2);
        return v_balance;
    exception
        when no_data_found then
            return null;
    end get_balance_amount;

  /* =====================================================
     Sync invoice status & paid/balance columns
     ===================================================== */
    procedure sync_invoice_payment_status (
        p_invoice_id in invoices.invoice_id%type
    ) is

        v_status  invoices.status%type;
        v_total   invoices.grand_total%type;
        v_paid    number := 0;
        v_balance number := 0;
    begin
    /* Lock invoice row */
        select
            status,
            grand_total
        into
            v_status,
            v_total
        from
            invoices
        where
            invoice_id = p_invoice_id
        for update;

    /* Only ISSUED/PARTIALLY_PAID/PAID can be affected by payments */
        if v_status = 'DRAFT' then
            raise_application_error(-20401, 'Cannot sync payments for a DRAFT invoice.');
        end if;
        v_paid := get_paid_amount(p_invoice_id);
        v_balance := round(v_total - v_paid, 2);

    /* Clamp negative balance (overpayment) if you want strict behavior:
       If you want to ALLOW overpayment, remove this clamp and store negative balance.
    */
        if v_balance < 0 then
            v_balance := v_balance; -- keep negative if you want overpayment tracking
        end if;

    /* Update cached amounts if columns exist */
        begin
            update invoices
            set
                paid_amount = round(v_paid, 2),
                balance_amount = round(v_balance, 2)
            where
                invoice_id = p_invoice_id;

        exception
            when others then
                null; -- if columns don't exist, ignore
        end;

    /* Update status */
        if round(v_paid, 2) <= 0 then
      /* Still ISSUED */
            update invoices
            set
                status = 'ISSUED'
            where
                    invoice_id = p_invoice_id
                and status <> 'PAID';

        elsif round(v_paid, 2) < round(v_total, 2) then
            update invoices
            set
                status = 'PARTIALLY_PAID'
            where
                    invoice_id = p_invoice_id
                and status <> 'PAID';

        else
            update invoices
            set
                status = 'PAID'
            where
                invoice_id = p_invoice_id;

        end if;

    exception
        when no_data_found then
            raise_application_error(-20402, 'Invoice not found.');
    end sync_invoice_payment_status;

  /* =====================================================
     Post Payment
     - Requires invoice status != DRAFT
     - Converts payment currency to invoice currency
     ===================================================== */
    procedure post_payment (
        p_invoice_id           in invoices.invoice_id%type,
        p_payment_method       in varchar2,
        p_currency_code        in varchar2,
        p_amount_orig          in number,
        p_exchange_rate_to_inv in number default null,
        p_paid_at              in timestamp default null,
        p_received_by          in varchar2,
        p_notes                in varchar2 default null,
        p_payment_id           out invoice_payments.payment_id%type
    ) is

        v_inv_currency invoices.currency_code%type;
        v_status       invoices.status%type;
        v_rate         number := 1;
        v_amt_inv      number := 0;
        v_paid_at      timestamp := nvl(p_paid_at, systimestamp);
    begin
        if p_amount_orig is null
           or p_amount_orig <= 0 then
            raise_application_error(-20410, 'Payment amount must be > 0.');
        end if;

    /* Lock invoice and validate */
        select
            currency_code,
            status
        into
            v_inv_currency,
            v_status
        from
            invoices
        where
            invoice_id = p_invoice_id
        for update;

        if v_status = 'DRAFT' then
            raise_application_error(-20411, 'Cannot post payment to a DRAFT invoice. Issue it first.');
        end if;
        if v_status = 'PAID' then
            raise_application_error(-20412, 'Invoice is already PAID.');
        end if;

    /* Rate logic */
        if upper(trim(p_currency_code)) = upper(trim(v_inv_currency)) then
            v_rate := 1;
        else
            v_rate := nvl_rate(p_exchange_rate_to_inv);
        end if;

        v_amt_inv := round(p_amount_orig * v_rate, 2);
        p_payment_id := gen_payment_id;
        insert into invoice_payments (
            payment_id,
            invoice_id,
            payment_method,
            payment_status,
            currency_code,
            amount_orig,
            exchange_rate_to_inv,
            amount_in_inv_currency,
            paid_at,
            received_by,
            notes,
            created_at,
            created_by
        ) values ( p_payment_id,
                   p_invoice_id,
                   upper(trim(p_payment_method)),
                   'POSTED',
                   upper(trim(p_currency_code)),
                   round(p_amount_orig, 2),
                   v_rate,
                   v_amt_inv,
                   v_paid_at,
                   p_received_by,
                   p_notes,
                   systimestamp,
                   p_received_by );

    /* Update invoice paid/balance/status */
        sync_invoice_payment_status(p_invoice_id);
        commit;
    exception
        when no_data_found then
            raise_application_error(-20413, 'Invoice not found.');
        when others then
            rollback;
            raise;
    end post_payment;

  /* =====================================================
     Void Payment (do not delete - audit trail)
     ===================================================== */
    procedure void_payment (
        p_payment_id in invoice_payments.payment_id%type,
        p_voided_by  in varchar2,
        p_reason     in varchar2 default null
    ) is
        v_invoice_id invoices.invoice_id%type;
        v_status     invoice_payments.payment_status%type;
    begin
        select
            invoice_id,
            payment_status
        into
            v_invoice_id,
            v_status
        from
            invoice_payments
        where
            payment_id = p_payment_id
        for update;

        if v_status <> 'POSTED' then
            raise_application_error(-20420, 'Only POSTED payments can be voided.');
        end if;
        update invoice_payments
        set
            payment_status = 'VOID',
            voided_at = systimestamp,
            voided_by = p_voided_by,
            void_reason = p_reason
        where
            payment_id = p_payment_id;

    /* Re-sync invoice status */
        sync_invoice_payment_status(v_invoice_id);
        commit;
    exception
        when no_data_found then
            raise_application_error(-20421, 'Payment not found.');
        when others then
            rollback;
            raise;
    end void_payment;

end utility_invoice_payments;
/


-- sqlcl_snapshot {"hash":"217c6fa78b121351f75fd8a2157f6e165bb96505","type":"PACKAGE_BODY","name":"UTILITY_INVOICE_PAYMENTS","schemaName":"WKSP_ELWAGHA50","sxml":""}