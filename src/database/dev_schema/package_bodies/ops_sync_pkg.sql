create or replace package body ops_sync_pkg as

/* =====================================================
   Log error
===================================================== */
    procedure log_error (
        p_item_id varchar2,
        p_source  varchar2,
        p_msg     varchar2
    ) is
    begin
        insert into ops_sync_errors (
            order_item_id,
            error_source,
            error_message,
            error_stack,
            created_by
        ) values ( p_item_id,
                   p_source,
                   substr(p_msg, 1, 4000),
                   dbms_utility.format_error_backtrace,
                   user );

    end;

/* =====================================================
   Add to retry queue
===================================================== */
    procedure enqueue_retry (
        p_item_id varchar2,
        p_error   varchar2
    ) is
    begin
        merge into ops_sync_queue q
        using (
            select
                p_item_id id
            from
                dual
        ) s on ( q.order_item_id = s.id
                 and q.status = 'PENDING' )
        when matched then update
        set retry_count = q.retry_count + 1,
            last_error = substr(p_error, 1, 4000),
            next_run_at = sysdate + interval '10' minute,
            updated_at = sysdate
        when not matched then
        insert (
            order_item_id,
            retry_count,
            last_error,
            next_run_at )
        values
            ( p_item_id,
              1,
              substr(p_error, 1, 4000),
              sysdate + interval '5' minute );

    end;

/* =====================================================
   Map raw status → canonical
===================================================== */
    function map_status (
        p_ref_table  varchar2,
        p_raw_status varchar2
    ) return varchar2 is
        v_status varchar2(30);
    begin
        select
            status_code
        into v_status
        from
            ops_status_map
        where
            ( ref_table = p_ref_table
              or ref_table = '*' )
            and raw_status = p_raw_status
        fetch first 1 rows only;

        return v_status;
    exception
        when no_data_found then
            return nvl(
                nullif(
                    trim(p_raw_status),
                    ''
                ),
                'NEW'
            );
    end;

/* =====================================================
   SLA calculator
===================================================== */
    procedure calc_sla (
        p_created    date,
        p_start_ts   timestamp,
        o_age_hours  out number,
        o_to_service out number
    ) is
    begin
        o_age_hours := round((sysdate - p_created) * 24, 2);
        if p_start_ts is not null then
            o_to_service := round((cast(p_start_ts as date) - sysdate) * 24, 2);

        else
            o_to_service := null;
        end if;

    end;

/* =====================================================
   Priority calculator
===================================================== */
    function calc_priority (
        p_status   varchar2,
        p_to_srv   number,
        p_amount   number,
        p_assigned varchar2
    ) return number is
        v_score number := 0;
    begin

  /* Time pressure */
        if p_to_srv is not null then
            if p_to_srv < 3 then
                v_score := v_score + 30;
            elsif p_to_srv < 12 then
                v_score := v_score + 20;
            else
                v_score := v_score + 10;
            end if;
        end if;

  /* Status */
        if p_status in ( 'NEW', 'PENDING_OPS' ) then
            v_score := v_score + 20;
        end if;

  /* High value */
        if nvl(p_amount, 0) >= 5000 then
            v_score := v_score + 10;
        end if;

  /* Not assigned */
        if p_assigned is null then
            v_score := v_score + 10;
        end if;
        return v_score;
    end;

/* =====================================================
   Sync single item (MAIN ENGINE)
===================================================== */
    procedure sync_item (
        p_order_item_id in varchar2
    ) is

        r_src    order_items%rowtype;
        r_main   main_reservations%rowtype;
        r_cli    clients%rowtype;
        v_phone  varchar2(50);
        v_status varchar2(30);
        v_age    number;
        v_to_srv number;
        v_prio   number;
        v_photo  varchar2(4000);
    begin

  /* Load order item */
        select
            *
        into r_src
        from
            order_items
        where
            order_item_id = p_order_item_id;

  /* Main reservation */
        select
            *
        into r_main
        from
            main_reservations
        where
            main_res_id = r_src.main_res_id;

  /* Client */
        select
            *
        into r_cli
        from
            clients
        where
            client_id = r_main.customer_id;

  /* Phone */
        begin
            select
                contact_value
            into v_phone
            from
                client_contacts
            where
                    client_id = r_cli.client_id
                and contact_type = 'PHONE'
                and rownum = 1;

        exception
            when no_data_found then
                v_phone := null;
        end;

  /* Status mapping */
        v_status := map_status(r_src.ref_table, r_src.fulfillment_status);

  /* SLA */
        calc_sla(r_src.created, r_src.service_start_ts, v_age, v_to_srv);

  /* Photo (LIMO only) */
        if r_src.ref_table = 'SUBLEVEL_LIMO_RES' then
            begin
                select
                    ct.main_photo_url
                into v_photo
                from
                         sublevel_limo_res lr
                    join limo_car_types ct on ct.car_type_id = lr.cat_item_id
                where
                    lr.sub_res_id = r_src.ref_id;

            exception
                when no_data_found then
                    v_photo := null;
            end;
        end if;

  /* Priority */
        v_prio := calc_priority(v_status, v_to_srv, r_src.amount_egp, r_src.assigned_to_name);

  /* UPSERT */
        merge into ops_orders_current t
        using dual on ( t.order_item_id = r_src.order_item_id )
        when matched then update
        set main_res_id = r_src.main_res_id,
            customer_id = r_main.customer_id,
            client_code = r_cli.client_code,
            client_phone = v_phone,
            item_type = r_src.item_type,
            ref_table = r_src.ref_table,
            ref_id = r_src.ref_id,
            service_title_ar = r_src.display_title_ar,
            service_subtitle_ar = r_src.display_subtitle_ar,
            service_photo_url = v_photo,
            status_code = v_status,
            raw_status = r_src.fulfillment_status,
            assigned_to_name = r_src.assigned_to_name,
            last_status_at = r_src.fulfillment_updated_at,
            last_status_by = r_src.fulfillment_updated_by,
            created_at = r_src.created,
            service_start_ts = r_src.service_start_ts,
            service_end_ts = r_src.service_end_ts,
            hours_to_service = v_to_srv,
            age_hours = v_age,
            amount_orig = r_src.amount_orig,
            currency = r_src.currency,
            amount_egp = r_src.amount_egp,
            priority_score = v_prio,
            last_sync_at = sysdate,
            updated_at = sysdate,
            updated_by = user,
            is_active = 'Y'
        when not matched then
        insert (
            order_item_id,
            main_res_id,
            customer_id,
            client_code,
            client_phone,
            item_type,
            ref_table,
            ref_id,
            service_title_ar,
            service_subtitle_ar,
            service_photo_url,
            status_code,
            raw_status,
            assigned_to_name,
            last_status_at,
            last_status_by,
            created_at,
            service_start_ts,
            service_end_ts,
            hours_to_service,
            age_hours,
            amount_orig,
            currency,
            amount_egp,
            priority_score,
            last_sync_at,
            is_active,
            created_by,
            updated_at )
        values
            ( r_src.order_item_id,
              r_src.main_res_id,
              r_main.customer_id,
              r_cli.client_code,
              v_phone,
              r_src.item_type,
              r_src.ref_table,
              r_src.ref_id,
              r_src.display_title_ar,
              r_src.display_subtitle_ar,
              v_photo,
              v_status,
              r_src.fulfillment_status,
              r_src.assigned_to_name,
              r_src.fulfillment_updated_at,
              r_src.fulfillment_updated_by,
              r_src.created,
              r_src.service_start_ts,
              r_src.service_end_ts,
              v_to_srv,
              v_age,
              r_src.amount_orig,
              r_src.currency,
              r_src.amount_egp,
              v_prio,
              sysdate,
              'Y',
              user,
              sysdate );

    exception
        when others then
            log_error(p_order_item_id, 'sync_item', sqlerrm);
            enqueue_retry(p_order_item_id, sqlerrm);
    end;

/* =====================================================
   Sync one main order
===================================================== */
    procedure sync_main (
        p_main_res_id in varchar2
    ) is
    begin
        for r in (
            select
                order_item_id
            from
                order_items
            where
                main_res_id = p_main_res_id
        ) loop
            sync_item(r.order_item_id);
        end loop;
    end;

/* =====================================================
   Full rebuild
===================================================== */
    procedure sync_all is
    begin
        for r in (
            select
                order_item_id
            from
                order_items
            where
                nvl(is_cancelled, 'N') = 'N'
        ) loop
            sync_item(r.order_item_id);
        end loop;
    end;

/* =====================================================
   Process retry queue
===================================================== */
    procedure process_queue is
    begin
        for r in (
            select
                *
            from
                ops_sync_queue
            where
                    status = 'PENDING'
                and next_run_at <= sysdate
            order by
                next_run_at
            fetch first 50 rows only
        ) loop
            begin
                update ops_sync_queue
                set
                    status = 'RUNNING'
                where
                    queue_id = r.queue_id;

                sync_item(r.order_item_id);
                update ops_sync_queue
                set
                    status = 'DONE',
                    updated_at = sysdate
                where
                    queue_id = r.queue_id;

            exception
                when others then
                    declare
                        v_err varchar2(4000);
                    begin
                        v_err := sqlerrm;
                        update ops_sync_queue
                        set
                            status = 'FAILED',
                            last_error = substr(v_err, 1, 4000),
                            updated_at = sysdate
                        where
                            queue_id = r.queue_id;

                    end;
            end;
        end loop;
    end;

end ops_sync_pkg;
/


-- sqlcl_snapshot {"hash":"907b6e59dbfe8d7f79c283c01c8b06bba955bc37","type":"PACKAGE_BODY","name":"OPS_SYNC_PKG","schemaName":"DEV_SCHEMA","sxml":""}