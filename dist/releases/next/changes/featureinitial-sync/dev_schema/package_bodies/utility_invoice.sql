-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463871139 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\utility_invoice.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/utility_invoice.sql:null:79c69c47ada3022ecb949b14938005b48178c808:create

create or replace package body utility_invoice as

    g_vat_rate constant number := 0.14;

  /* ===================================================== */
    function get_invoice_id (
        p_main_res_id in varchar2
    ) return varchar2 is
        v_id varchar2(30);
    begin
        select
            invoice_id
        into v_id
        from
            invoices
        where
            main_res_id = p_main_res_id;

        return v_id;
    exception
        when no_data_found then
            return null;
    end;

  /* ===================================================== */
    procedure assert_draft (
        p_invoice_id in varchar2
    ) is
        v_status varchar2(20);
    begin
        select
            status
        into v_status
        from
            invoices
        where
            invoice_id = p_invoice_id;

        if v_status <> 'DRAFT' then
            raise_application_error(-20001, 'Invoice is not editable');
        end if;
    end;

  /* ===================================================== */
    procedure create_invoice (
        p_main_res_id in varchar2,
        p_created_by  in varchar2
    ) is
        v_exists   number;
        v_id       varchar2(30);
        v_currency varchar2(10);
    begin
        select
            count(*)
        into v_exists
        from
            invoices
        where
            main_res_id = p_main_res_id;

        if v_exists > 0 then
            return;
        end if;
        select
            currency_code
        into v_currency
        from
            main_reservations
        where
            main_res_id = p_main_res_id;

        v_id := 'INV-'
                || substr(
            replace(
                sys_guid(), '-'
            ),
            1,
            12
        );

        insert into invoices (
            invoice_id,
            main_res_id,
            invoice_date,
            due_date,
            currency_code,
            status,
            created_at,
            created_by,
            vat_included,
            vat_rate,
            total_amount,
            tax_amount,
            grand_total
        ) values ( v_id,
                   p_main_res_id,
                   sysdate,
                   sysdate + 7,
                   v_currency,
                   'DRAFT',
                   sysdate,
                   p_created_by,
                   'Y',
                   case
                       when v_currency = 'EGP' then
                           g_vat_rate
                       else
                           0
                   end,
                   0,
                   0,
                   0 );

        refresh_invoice(p_main_res_id);
    end;

  /* ===================================================== */
    procedure refresh_invoice (
        p_main_res_id in varchar2
    ) is

        v_invoice_id varchar2(30);
        v_subtotal   number := 0;
        v_adj        number := 0;
        v_net        number := 0;
        v_vat        number := 0;
        v_rate       number := 0;
        v_flag       varchar2(1);
    begin
        v_invoice_id := get_invoice_id(p_main_res_id);
        if v_invoice_id is null then
            return;
        end if;
        assert_draft(v_invoice_id);

    /* rebuild lines */
        delete from invoice_lines
        where
            invoice_id = v_invoice_id;

        insert into invoice_lines (
            invoice_id,
            source_order_id,
            source_item_id,
            description,
            quantity,
            unit_price,
            total_price
        )
            select
                v_invoice_id,
                oi.main_res_id,
                oi.order_item_id,
                nvl(oi.display_title_ar, oi.item_type),
                1,
                oi.amount_orig,
                oi.amount_orig
            from
                order_items oi
            where
                    oi.main_res_id = p_main_res_id
                and nvl(oi.is_cancelled, 'N') = 'N';

    /* calculations */
        select
            nvl(
                sum(total_price),
                0
            )
        into v_subtotal
        from
            invoice_lines
        where
            invoice_id = v_invoice_id;

        select
            nvl(
                sum(amount),
                0
            )
        into v_adj
        from
            invoice_adjustments
        where
            invoice_id = v_invoice_id;

        select
            vat_rate,
            vat_included
        into
            v_rate,
            v_flag
        from
            invoices
        where
            invoice_id = v_invoice_id;

        v_net := v_subtotal + v_adj;
        if v_flag = 'Y' then
            v_vat := round(v_net * v_rate, 2);
        end if;

        update invoices
        set
            total_amount = v_net,
            tax_amount = v_vat,
            grand_total = v_net + v_vat,
            balance_amount = v_net + v_vat
        where
            invoice_id = v_invoice_id;

    end;

  /* ===================================================== */
    procedure apply_promo (
        p_main_res_id   in varchar2,
        p_discount_type in varchar2,
        p_value         in number,
        p_created_by    in varchar2
    ) is
        v_invoice_id varchar2(30);
        v_subtotal   number;
        v_discount   number;
    begin
        v_invoice_id := get_invoice_id(p_main_res_id);
        assert_draft(v_invoice_id);
        select
            nvl(
                sum(total_price),
                0
            )
        into v_subtotal
        from
            invoice_lines
        where
            invoice_id = v_invoice_id;

        if p_discount_type = 'PERCENT' then
            v_discount := -round(v_subtotal *(p_value / 100), 2);
        else
            v_discount := -least(p_value, v_subtotal);
        end if;

        insert into invoice_adjustments (
            invoice_id,
            adjustment_type,
            description,
            amount,
            created_at,
            created_by
        ) values ( v_invoice_id,
                   'DISCOUNT',
                   'Promo',
                   v_discount,
                   sysdate,
                   p_created_by );

        refresh_invoice(p_main_res_id);
    end;

  /* ===================================================== */
    procedure remove_promos (
        p_main_res_id in varchar2
    ) is
        v_invoice_id varchar2(30);
    begin
        v_invoice_id := get_invoice_id(p_main_res_id);
        assert_draft(v_invoice_id);
        delete from invoice_adjustments
        where
            invoice_id = v_invoice_id;

        refresh_invoice(p_main_res_id);
    end;

  /* ===================================================== */
    procedure issue_invoice (
        p_main_res_id in varchar2
    ) is
        v_invoice_id varchar2(30);
        v_no         varchar2(50);
    begin
        v_invoice_id := get_invoice_id(p_main_res_id);
        refresh_invoice(p_main_res_id);
        select
            invoice_no
        into v_no
        from
            invoices
        where
            invoice_id = v_invoice_id
        for update;

        if v_no is null then
            v_no := 'INV-'
                    || to_char(sysdate, 'YYYYMMDD')
                    || '-'
                    || substr(
                replace(
                    sys_guid(), '-'
                ),
                1,
                6
            );
        end if;

        update invoices
        set
            status = 'ISSUED',
            invoice_no = v_no
        where
            invoice_id = v_invoice_id;

    end;

end utility_invoice;
/

