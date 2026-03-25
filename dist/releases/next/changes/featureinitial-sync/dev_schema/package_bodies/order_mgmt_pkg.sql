-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463867564 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\order_mgmt_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/order_mgmt_pkg.sql:null:201a6578d41e6834501fa6aab0b9c711cc7c4fed:create

create or replace package body order_mgmt_pkg as

    function is_open_order_status (
        p_status in varchar2
    ) return boolean is
    begin
        return upper(nvl(p_status, 'X')) not in ( 'COMPLETED', 'CANCELLED' );
    end;

    function is_payable_payment_status (
        p_pay in varchar2
    ) return boolean is
    begin
        return upper(nvl(p_pay, 'X')) in ( 'CART', 'PAYMENT_FAILED' );
    end;

    function get_app_user return varchar2 is
    begin
        return nvl(
            sys_context('APEX$SESSION', 'APP_USER_ID'),
            user
        );
    end;

  /* =====================================================
     Get or create ACTIVE order (CART)
     ===================================================== */
    function get_or_create_active_order (
        p_customer_id in varchar2,
        p_currency    in varchar2 default 'EGP'
    ) return varchar2 is
        v_main_res_id varchar2(30);
        v_user        varchar2(200);
    begin
        v_user := get_app_user;

    /* 1) Get latest OPEN order that is still CART (or failed payment retry) */
        begin
            select
                m.main_res_id
            into v_main_res_id
            from
                main_reservations m
            where
                    m.customer_id = p_customer_id
                and upper(nvl(m.status, 'X')) not in ( 'COMPLETED', 'CANCELLED' )
                and upper(nvl(m.payment_status, 'CART')) in ( 'CART', 'PAYMENT_FAILED' )
            order by
                m.created desc
            fetch first 1 row only;

      /* lock */
            select
                main_res_id
            into v_main_res_id
            from
                main_reservations
            where
                main_res_id = v_main_res_id
            for update;

            return v_main_res_id;
        exception
            when no_data_found then
                null;
        end;

    /* 2) Create new CART order */
        insert into main_reservations (
            customer_id,
            currency_code,
            status,
            payment_status,
            notes,
            created,
            created_by
        ) values ( p_customer_id,
                   p_currency,
                   'CART',
                   'CART',
                   null,
                   systimestamp,
                   v_user ) returning main_res_id into v_main_res_id;

    /* Create draft invoice immediately */
        utility_invoice.create_invoice(
            p_main_res_id => v_main_res_id,
            p_created_by  => v_user
        );
        return v_main_res_id;
    exception
        when dup_val_on_index then
            select
                m.main_res_id
            into v_main_res_id
            from
                main_reservations m
            where
                    m.customer_id = p_customer_id
                and upper(nvl(m.status, 'X')) not in ( 'COMPLETED', 'CANCELLED' )
                and upper(nvl(m.payment_status, 'CART')) in ( 'CART', 'PAYMENT_FAILED' )
            order by
                m.created desc
            fetch first 1 row only;

            return v_main_res_id;
    end get_or_create_active_order;

  /* =====================================================
     Assert order is OPEN
     ===================================================== */
    procedure assert_order_is_active (
        p_main_res_id in varchar2
    ) is
        v_status varchar2(200);
    begin
        select
            status
        into v_status
        from
            main_reservations
        where
            main_res_id = p_main_res_id;

        if not is_open_order_status(v_status) then
            raise_application_error(-20001, 'Order is not OPEN. Current status = ' || v_status);
        end if;

    end;

  /* =====================================================
     Assert order can be paid
     ===================================================== */
    procedure assert_order_is_payable (
        p_main_res_id in varchar2
    ) is
        v_pay varchar2(30);
        v_cnt number;
    begin
        assert_order_is_active(p_main_res_id);
        select
            payment_status
        into v_pay
        from
            main_reservations
        where
            main_res_id = p_main_res_id
        for update;

        if not is_payable_payment_status(v_pay) then
            raise_application_error(-20040, 'Order is not payable. payment_status=' || v_pay);
        end if;

        select
            count(*)
        into v_cnt
        from
            order_items
        where
                main_res_id = p_main_res_id
            and nvl(is_cancelled, 'N') = 'N';

        if v_cnt = 0 then
            raise_application_error(-20041, 'Cannot checkout empty cart.');
        end if;
    end;

  /* =====================================================
     Add item
     - IS_CONFIRMED stays N until payment
     - block adding items after checkout started
     - refresh invoice after insert/update
     ===================================================== */
    procedure add_item (
        p_main_res_id   in varchar2,
        p_item_type     in varchar2,
        p_ref_table     in varchar2,
        p_ref_id        in varchar2,
        p_item_status   in varchar2,
        p_amount_orig   in number,
        p_currency      in varchar2,
        p_exchange_rate in number,
        p_source        in varchar2,
        o_order_item_id out varchar2,
        o_created_at    out timestamp,
        o_created_by    out varchar2
    ) is

        v_user    varchar2(200);
        v_id      varchar2(30);
        v_amt_egp number(12, 2);
        v_pay     varchar2(30);
        v_source  varchar2(20);
    begin
        v_user := get_app_user;
        assert_order_is_active(p_main_res_id);
        select
            payment_status
        into v_pay
        from
            main_reservations
        where
            main_res_id = p_main_res_id;

        if upper(nvl(v_pay, 'CART')) in ( 'PAYMENT_PENDING', 'PAID' ) then
            raise_application_error(-20042, 'Cannot add items after checkout. payment_status=' || v_pay);
        end if;

        v_source := upper(substr(
            trim(p_source),
            1,
            20
        ));
        if v_source is null then
            raise_application_error(-20043, 'SOURCE is required');
        end if;
        if v_source not in ( 'WEB', 'MOBILE', 'MANUAL' ) then
            raise_application_error(-20044, 'Invalid source: ' || v_source);
        end if;

        o_created_at := systimestamp;
        o_created_by := v_user;
        v_id := 'OI-'
                || lpad(order_item_seq.nextval, 8, '0');
        v_amt_egp := nvl(p_amount_orig, 0) * nvl(p_exchange_rate, 1);
        insert into order_items (
            order_item_id,
            main_res_id,
            item_type,
            ref_table,
            ref_id,
            item_status,
            amount_orig,
            currency,
            exchange_rate,
            amount_egp,
            source,
            created,
            created_by,
            is_cancelled,
            fulfillment_status,
            fulfillment_updated_at,
            fulfillment_updated_by,
            is_confirmed
        ) values ( v_id,
                   p_main_res_id,
                   p_item_type,
                   p_ref_table,
                   p_ref_id,
                   nvl(p_item_status, 'CART'),
                   p_amount_orig,
                   p_currency,
                   p_exchange_rate,
                   v_amt_egp,
                   v_source,
                   o_created_at,
                   o_created_by,
                   'N',
                   'NEW',
                   o_created_at,
                   o_created_by,
                   'N' );

        o_order_item_id := v_id;
        utility_invoice.refresh_invoice(p_main_res_id);
    exception
        when dup_val_on_index then
            update_item(
                p_item_type     => p_item_type,
                p_ref_id        => p_ref_id,
                p_item_status   => p_item_status,
                p_amount_orig   => p_amount_orig,
                p_currency      => p_currency,
                p_exchange_rate => p_exchange_rate,
                o_updated_at    => o_created_at,
                o_updated_by    => o_created_by
            );

            select
                order_item_id,
                main_res_id
            into
                o_order_item_id,
                v_id
            from
                (
                    select
                        order_item_id,
                        main_res_id
                    from
                        order_items
                    where
                            ref_id = p_ref_id
                        and item_type = p_item_type
                    order by
                        created desc
                )
            where
                rownum = 1;

            utility_invoice.refresh_invoice(v_id);
    end add_item;

  /* =====================================================
     Update item
     - note: scoped by latest matching item row
     - refresh invoice after update
     ===================================================== */
    procedure update_item (
        p_item_type     in varchar2,
        p_ref_id        in varchar2,
        p_item_status   in varchar2,
        p_amount_orig   in number,
        p_currency      in varchar2,
        p_exchange_rate in number,
        o_updated_at    out timestamp,
        o_updated_by    out varchar2
    ) is
        v_amt_egp     number(12, 2);
        v_main_res_id varchar2(30);
    begin
        o_updated_by := get_app_user;
        o_updated_at := systimestamp;
        v_amt_egp := nvl(p_amount_orig, 0) * nvl(p_exchange_rate, 1);
        select
            main_res_id
        into v_main_res_id
        from
            (
                select
                    main_res_id
                from
                    order_items
                where
                        item_type = p_item_type
                    and ref_id = p_ref_id
                order by
                    created desc
            )
        where
            rownum = 1;

        update order_items
        set
            item_status = p_item_status,
            amount_orig = p_amount_orig,
            currency = p_currency,
            exchange_rate = p_exchange_rate,
            amount_egp = v_amt_egp,
            updated = o_updated_at,
            updated_by = o_updated_by
        where
            order_item_id = (
                select
                    order_item_id
                from
                    (
                        select
                            order_item_id
                        from
                            order_items
                        where
                                item_type = p_item_type
                            and ref_id = p_ref_id
                        order by
                            created desc
                    )
                where
                    rownum = 1
            );

        if sql%rowcount = 0 then
            raise_application_error(-20045, 'Order item not found for update.');
        end if;
        utility_invoice.refresh_invoice(v_main_res_id);
    end update_item;

  /* =====================================================
     Cancel item
     - refresh invoice after cancel
     ===================================================== */
    procedure cancel_item (
        p_item_type  in varchar2,
        p_ref_id     in varchar2,
        o_updated_at out timestamp,
        o_updated_by out varchar2
    ) is
        v_main_res_id varchar2(30);
    begin
        o_updated_by := get_app_user;
        o_updated_at := systimestamp;
        select
            main_res_id
        into v_main_res_id
        from
            (
                select
                    main_res_id
                from
                    order_items
                where
                        item_type = p_item_type
                    and ref_id = p_ref_id
                order by
                    created desc
            )
        where
            rownum = 1;

        update order_items
        set
            item_status = 'CANCELLED',
            is_cancelled = 'Y',
            fulfillment_status = 'CANCELLED',
            fulfillment_updated_at = o_updated_at,
            fulfillment_updated_by = o_updated_by,
            updated = o_updated_at,
            updated_by = o_updated_by
        where
            order_item_id = (
                select
                    order_item_id
                from
                    (
                        select
                            order_item_id
                        from
                            order_items
                        where
                                item_type = p_item_type
                            and ref_id = p_ref_id
                        order by
                            created desc
                    )
                where
                    rownum = 1
            );

        if sql%rowcount = 0 then
            raise_application_error(-20046, 'Order item not found for cancel.');
        end if;
        utility_invoice.refresh_invoice(v_main_res_id);
    end cancel_item;

  /* =====================================================
     Complete order
     ===================================================== */
    procedure complete_order (
        p_main_res_id in varchar2,
        p_user_id     in varchar2
    ) is
        v_open_items  number;
        v_total_items number;
    begin
        assert_order_is_active(p_main_res_id);
        select
            count(*)
        into v_total_items
        from
            order_items
        where
            main_res_id = p_main_res_id;

        if v_total_items = 0 then
            raise_application_error(-20002, 'Cannot complete reservation with no items.');
        end if;
        select
            count(*)
        into v_open_items
        from
            order_items
        where
                main_res_id = p_main_res_id
            and upper(nvl(fulfillment_status, 'NEW')) not in ( 'COMPLETED', 'CANCELLED' );

        if v_open_items > 0 then
            raise_application_error(-20003, 'Cannot complete reservation. Some items still not completed.');
        end if;
        update main_reservations
        set
            status = 'COMPLETED',
            updated = systimestamp,
            updated_by = p_user_id
        where
            main_res_id = p_main_res_id;

    end complete_order;

  /* =====================================================
     Set item snapshot
     - refresh invoice because displayed title can affect line description
     ===================================================== */
    procedure set_item_snapshot (
        p_order_item_id       in varchar2,
        p_display_title_ar    in varchar2,
        p_display_subtitle_ar in varchar2 default null,
        p_service_start_ts    in timestamp default null,
        p_service_end_ts      in timestamp default null,
        p_assigned_to_emp_id  in number default null,
        p_assigned_to_name    in varchar2 default null,
        p_meta_json           in clob default null
    ) is
        v_main_res_id varchar2(30);
    begin
        if p_order_item_id is null then
            raise_application_error(-20011, 'ORDER_ITEM_ID is required');
        end if;
        select
            main_res_id
        into v_main_res_id
        from
            order_items
        where
            order_item_id = p_order_item_id;

        update order_items
        set
            display_title_ar = substr(p_display_title_ar, 1, 500),
            display_subtitle_ar = substr(p_display_subtitle_ar, 1, 1000),
            service_start_ts = p_service_start_ts,
            service_end_ts = p_service_end_ts,
            assigned_to_emp_id = p_assigned_to_emp_id,
            assigned_to_name = substr(p_assigned_to_name, 1, 255),
            meta_json = p_meta_json
        where
            order_item_id = p_order_item_id;

        if sql%rowcount = 0 then
            raise_application_error(-20012, 'ORDER_ITEM_ID not found: ' || p_order_item_id);
        end if;

        utility_invoice.refresh_invoice(v_main_res_id);
    end set_item_snapshot;

  /* =========================
     Payment lifecycle
     ========================= */

    procedure initiate_checkout (
        p_main_res_id in varchar2,
        p_provider    in varchar2,
        p_payment_ref in varchar2,
        p_user_id     in varchar2
    ) is
        v_user varchar2(200);
    begin
        v_user := nvl(p_user_id, get_app_user);
        assert_order_is_payable(p_main_res_id);
        update main_reservations
        set
            payment_status = 'PAYMENT_PENDING',
            payment_provider = substr(p_provider, 1, 30),
            payment_ref = substr(p_payment_ref, 1, 200),
            checked_out_at = systimestamp,
            payment_updated_at = systimestamp,
            payment_updated_by = v_user,
            updated = systimestamp,
            updated_by = v_user
        where
            main_res_id = p_main_res_id;

        commit;
    end initiate_checkout;

    procedure confirm_payment (
        p_main_res_id in varchar2,
        p_provider    in varchar2,
        p_payment_ref in varchar2,
        p_user_id     in varchar2
    ) is
        v_user  varchar2(200);
        v_dummy varchar2(30);
    begin
        v_user := nvl(p_user_id, get_app_user);
        select
            main_res_id
        into v_dummy
        from
            main_reservations
        where
            main_res_id = p_main_res_id
        for update;

        update main_reservations
        set
            payment_status = 'PAID',
            payment_provider = substr(
                nvl(p_provider, payment_provider),
                1,
                30
            ),
            payment_ref = substr(
                nvl(p_payment_ref, payment_ref),
                1,
                200
            ),
            paid_at = systimestamp,
            payment_updated_at = systimestamp,
            payment_updated_by = v_user,
            status = 'PENDINGOPS',
            updated = systimestamp,
            updated_by = v_user
        where
            main_res_id = p_main_res_id;

        update order_items
        set
            is_confirmed = 'Y',
            item_status =
                case
                    when upper(nvl(item_status, 'X')) = 'CANCELLED' then
                        item_status
                    else
                        'PENDING_ASSIGNMENT'
                end,
            updated = systimestamp,
            updated_by = v_user
        where
                main_res_id = p_main_res_id
            and nvl(is_cancelled, 'N') = 'N';

        utility_invoice.issue_invoice(p_main_res_id);
        commit;
    end confirm_payment;

    procedure fail_payment (
        p_main_res_id in varchar2,
        p_provider    in varchar2,
        p_payment_ref in varchar2,
        p_reason      in varchar2,
        p_user_id     in varchar2
    ) is
        v_user varchar2(200);
    begin
        v_user := nvl(p_user_id, get_app_user);
        update main_reservations
        set
            payment_status = 'PAYMENT_FAILED',
            payment_provider = substr(
                nvl(p_provider, payment_provider),
                1,
                30
            ),
            payment_ref = substr(
                nvl(p_payment_ref, payment_ref),
                1,
                200
            ),
            notes = substr(nvl(notes, '')
                           || chr(10)
                           || 'PAYMENT_FAILED: '
                           || nvl(p_reason, '-'),
                           1,
                           1000),
            payment_updated_at = systimestamp,
            payment_updated_by = v_user,
            updated = systimestamp,
            updated_by = v_user
        where
            main_res_id = p_main_res_id;

        commit;
    end fail_payment;

    procedure expire_stale_carts (
        p_hours_old in number default 6
    ) is
        v_user varchar2(200);
    begin
        v_user := get_app_user;
        update main_reservations
        set
            payment_status = 'EXPIRED',
            status = 'CANCELLED',
            payment_updated_at = systimestamp,
            payment_updated_by = v_user,
            updated = systimestamp,
            updated_by = v_user
        where
            upper(nvl(payment_status, 'CART')) in ( 'CART', 'PAYMENT_PENDING' )
            and created < systimestamp - numtodsinterval(
                nvl(p_hours_old, 6),
                'HOUR'
            );

        commit;
    end expire_stale_carts;

end order_mgmt_pkg;
/

