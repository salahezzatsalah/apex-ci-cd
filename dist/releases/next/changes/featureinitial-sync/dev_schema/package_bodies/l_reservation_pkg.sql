-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463859985 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\l_reservation_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/l_reservation_pkg.sql:null:2dd9c0569135cddfccc84a79b7a23afb2336321d:create

create or replace package body l_reservation_pkg as

  /* ================================
     helpers
     ================================ */
    function nod (
        p_from date,
        p_to   date
    ) return number is
    begin
        if p_from is null then
            return 0;
        end if;
        return trunc(nvl(p_to, p_from)) - trunc(p_from) + 1;
    end nod;

    function calc_total_amount (
        p_price number,
        p_from  date,
        p_to    date
    ) return number is
    begin
        return nvl(p_price, 0) * nod(p_from, p_to);
    end calc_total_amount;

    function trim_str (
        p_val varchar2,
        p_len pls_integer
    ) return varchar2 is
    begin
        return substr(p_val, 1, p_len);
    end trim_str;

  /* build TIMESTAMP from DATE + 'HH24:MI' */
    function make_ts (
        p_date date,
        p_time varchar2
    ) return timestamp is
    begin
        if p_date is null then
            return null;
        end if;
        return cast ( trunc(p_date) + ( to_date(nvl(p_time, '00:00'),
        'HH24:MI') - trunc(to_date(nvl(p_time, '00:00'),
      'HH24:MI')) ) as timestamp );

    end make_ts;

  /* refresh MAIN_RESERVATIONS.TOTAL_AMOUNT from ORDER_ITEMS */
    procedure refresh_main_order_total (
        p_main_res_id in main_reservations.main_res_id%type
    ) is
    begin
        update main_reservations mr
        set
            total_amount = (
                select
                    nvl(
                        sum(nvl(oi.amount_egp, oi.amount_orig)),
                        0
                    )
                from
                    order_items oi
                where
                        oi.main_res_id = mr.main_res_id
                    and nvl(oi.is_cancelled, 'N') = 'N'
            )
        where
            mr.main_res_id = p_main_res_id;

    end refresh_main_order_total;

  /* =====================================================
     CREATE
     ===================================================== */
    procedure create_limo_res (
        p_main_res_id     in out varchar2,
        p_sub_res_id      in out varchar2,
        p_customer_id     in varchar2,
        p_trip_type       in varchar2,
        p_from_location   in varchar2,
        p_to_location     in varchar2,
        p_from_place_id   in varchar2,
        p_to_place_id     in varchar2,
        p_currency        in varchar2,
        p_exchange_rate   in number,
        p_ticket_number   in varchar2,
        p_signage_details in varchar2,
        p_notes           in varchar2,
        p_status          in varchar2,
        p_cat_item_id     in varchar2,
        p_res_date_from   in date,
        p_res_date_to     in date,
        p_res_time        in varchar2,
        p_service_class   in varchar2,
        p_trip_price      in number,
        p_ticket_url      in varchar2,
        p_source          in sublevel_limo_res.source%type,
        p_passengers_no   in sublevel_limo_res.passengers_no%type default null,
        p_luggage_no      in sublevel_limo_res.luggage_no%type default null,
        p_request_type    in sublevel_limo_res.request_type%type default null,
        o_result          out t_result
    ) as

        v_sub_res_id         varchar2(30);
        v_order_item_id      varchar2(30);
        v_status_trim        varchar2(30);
        v_trip_type_trim     varchar2(20);
        v_from_loc_trim      varchar2(400);
        v_to_loc_trim        varchar2(400);
        v_from_place_id_trim varchar2(200);
        v_to_place_id_trim   varchar2(200);
        v_service_class_trim varchar2(50);
        v_ticket_number_trim varchar2(300);
        v_signage_trim       varchar2(300);
        v_notes_trim         varchar2(1000);
        v_request_type_trim  varchar2(50);
        v_ticket_url_trim    varchar2(4000);
        v_source_trim        varchar2(20);
        v_total_amount       number(12, 2);
        l_created_at         timestamp;
        l_created_by         varchar2(200);
        v_trip_type_name_ar  varchar2(100);
        v_car_type_name      varchar2(255);
        v_title_ar           varchar2(500);
        v_subtitle_ar        varchar2(1000);
        v_start_ts           timestamp;
        v_end_ts             timestamp;
        v_meta_json          clob;
    begin
        o_result.sub_res_id := null;
        o_result.main_res_id := null;
        o_result.status_message := null;
        p_sub_res_id := null;

    /* Resolve active order */
        if p_main_res_id is null then
            if p_customer_id is null then
                o_result.status_message := 'ERROR: CUSTOMER_ID is required';
                return;
            end if;
            p_main_res_id := order_mgmt_pkg.get_or_create_active_order(
                p_customer_id => p_customer_id,
                p_currency    => p_currency
            );
        end if;

        order_mgmt_pkg.assert_order_is_active(p_main_res_id);

    /* Guards */
        if p_trip_type is null
           or p_res_date_from is null
        or p_trip_price is null then
            o_result.status_message := 'ERROR: Missing required fields';
            return;
        end if;

    /* Trim */
        v_status_trim := trim_str(
            nvl(p_status, 'CART'),
            30
        );
        v_trip_type_trim := trim_str(p_trip_type, 20);
        v_from_loc_trim := trim_str(p_from_location, 400);
        v_to_loc_trim := trim_str(p_to_location, 400);
        v_from_place_id_trim := trim_str(p_from_place_id, 200);
        v_to_place_id_trim := trim_str(p_to_place_id, 200);
        v_service_class_trim := trim_str(p_service_class, 50);
        v_ticket_number_trim := trim_str(p_ticket_number, 300);
        v_signage_trim := trim_str(p_signage_details, 300);
        v_notes_trim := trim_str(p_notes, 1000);
        v_request_type_trim := trim_str(p_request_type, 50);
        v_ticket_url_trim := trim_str(p_ticket_url, 4000);
        v_source_trim := upper(trim_str(p_source, 20));
        if v_source_trim is null then
            o_result.status_message := 'ERROR: SOURCE is required';
            return;
        end if;
        if v_source_trim not in ( 'WEB', 'MOBILE', 'MANUAL' ) then
            o_result.status_message := 'ERROR: INVALID_SOURCE';
            return;
        end if;

    /* IDs */
        v_sub_res_id := 'LIMO-'
                        || lpad(seq_sublimo_sub_res.nextval, 6, '0');
        p_sub_res_id := v_sub_res_id;
        v_total_amount := calc_total_amount(p_trip_price, p_res_date_from, p_res_date_to);

    /* CREATE ORDER ITEM */
        order_mgmt_pkg.add_item(
            p_main_res_id   => p_main_res_id,
            p_item_type     => 'LIMO',
            p_ref_table     => 'SUBLEVEL_LIMO_RES',
            p_ref_id        => v_sub_res_id,
            p_item_status   => v_status_trim,
            p_amount_orig   => v_total_amount,
            p_currency      => p_currency,
            p_exchange_rate => p_exchange_rate,
            p_source        => v_source_trim,
            o_order_item_id => v_order_item_id,
            o_created_at    => l_created_at,
            o_created_by    => l_created_by
        );

    /* refresh order header total */
        refresh_main_order_total(p_main_res_id);

    /* Snapshot data */
        begin
            select
                name_ar
            into v_trip_type_name_ar
            from
                limo_trip_types
            where
                trip_type_code = v_trip_type_trim;

        exception
            when no_data_found then
                v_trip_type_name_ar := v_trip_type_trim;
        end;

        begin
            select
                car_type_name
            into v_car_type_name
            from
                limo_car_types
            where
                car_type_id = p_cat_item_id;

        exception
            when no_data_found then
                v_car_type_name := p_cat_item_id;
        end;

        v_title_ar := 'ليموزين - ' || nvl(v_trip_type_name_ar, v_trip_type_trim);
        v_subtitle_ar := nvl(v_car_type_name, '-')
                         || ' - '
                         || nvl(v_from_loc_trim, '-')
                         || ' <- '
                         || nvl(v_to_loc_trim, '-');

        v_start_ts := make_ts(p_res_date_from, p_res_time);
        v_end_ts := cast ( trunc(nvl(p_res_date_to, p_res_date_from)) as timestamp );
        v_meta_json :=
            json_object(
                'tripTypeCode' value v_trip_type_trim,
                        'tripTypeNameAr' value v_trip_type_name_ar,
                        'carTypeId' value p_cat_item_id,
                        'carTypeName' value v_car_type_name,
                        'nod' value nod(p_res_date_from, p_res_date_to),
                        'ticketNumber' value v_ticket_number_trim,
                        'signage' value v_signage_trim,
                        'fromPlaceId' value v_from_place_id_trim,
                        'toPlaceId' value v_to_place_id_trim,
                        'source' value v_source_trim
            );

        order_mgmt_pkg.set_item_snapshot(
            p_order_item_id       => v_order_item_id,
            p_display_title_ar    => v_title_ar,
            p_display_subtitle_ar => v_subtitle_ar,
            p_service_start_ts    => v_start_ts,
            p_service_end_ts      => v_end_ts,
            p_meta_json           => v_meta_json
        );

    /* INSERT SUBLEVEL ROW */
        insert into sublevel_limo_res (
            sub_res_id,
            order_item_id,
            main_res_id,
            cat_item_id,
            trip_type,
            from_location,
            to_location,
            from_place_id,
            to_place_id,
            res_date_from,
            res_date_to,
            res_time,
            service_class,
            trip_price,
            currency,
            exchange_rate,
            ticket_number,
            signage_details,
            notes,
            status,
            passengers_no,
            luggage_no,
            request_type,
            ticket_url,
            source,
            created,
            created_by
        ) values ( v_sub_res_id,
                   v_order_item_id,
                   p_main_res_id,
                   p_cat_item_id,
                   v_trip_type_trim,
                   v_from_loc_trim,
                   v_to_loc_trim,
                   v_from_place_id_trim,
                   v_to_place_id_trim,
                   p_res_date_from,
                   p_res_date_to,
                   p_res_time,
                   v_service_class_trim,
                   p_trip_price,
                   p_currency,
                   p_exchange_rate,
                   v_ticket_number_trim,
                   v_signage_trim,
                   v_notes_trim,
                   v_status_trim,
                   p_passengers_no,
                   p_luggage_no,
                   v_request_type_trim,
                   v_ticket_url_trim,
                   v_source_trim,
                   l_created_at,
                   l_created_by );

        commit;
        o_result.sub_res_id := v_sub_res_id;
        o_result.main_res_id := p_main_res_id;
        o_result.status_message := 'SUCCESS';
    exception
        when others then
            rollback;
            o_result.sub_res_id := p_sub_res_id;
            o_result.main_res_id := p_main_res_id;
            o_result.status_message := sqlerrm;
    end create_limo_res;

  /* =====================================================
     UPDATE (PATCH-friendly)
     ===================================================== */
    procedure update_limo_res (
        p_sub_res_id      in varchar2,
        p_cat_item_id     in varchar2,
        p_trip_type       in varchar2,
        p_res_date_from   in date,
        p_res_date_to     in date,
        p_res_time        in varchar2,
        p_from_location   in varchar2,
        p_to_location     in varchar2,
        p_from_place_id   in varchar2,
        p_to_place_id     in varchar2,
        p_service_class   in varchar2,
        p_trip_price      in number,
        p_ticket_number   in varchar2,
        p_signage_details in varchar2,
        p_notes           in varchar2,
        p_status          in varchar2,
        p_ticket_url      in varchar2,
        p_source          in sublevel_limo_res.source%type,
        p_passengers_no   in sublevel_limo_res.passengers_no%type default null,
        p_luggage_no      in sublevel_limo_res.luggage_no%type default null,
        p_request_type    in sublevel_limo_res.request_type%type default null,
        o_result          out t_result
    ) as

        v_main_res           varchar2(30);
        v_curr               varchar2(10);
        v_exrate             number;
        v_old_from           date;
        v_old_to             date;
        v_old_time           varchar2(10);
        v_old_price          number;
        v_old_cat            varchar2(30);
        v_old_trip           varchar2(20);
        v_old_from_loc       varchar2(400);
        v_old_to_loc         varchar2(400);
        v_old_from_pid       varchar2(200);
        v_old_to_pid         varchar2(200);
        v_old_class          varchar2(50);
        v_old_ticket_no      varchar2(300);
        v_old_signage        varchar2(300);
        v_old_notes          varchar2(1000);
        v_old_status         varchar2(30);
        v_old_pax            sublevel_limo_res.passengers_no%type;
        v_old_bags           sublevel_limo_res.luggage_no%type;
        v_old_req            sublevel_limo_res.request_type%type;
        v_old_ticket_url     varchar2(4000);
        v_old_source         varchar2(20);
        v_order_item_id      varchar2(30);
        v_new_from           date;
        v_new_to             date;
        v_new_time           varchar2(10);
        v_new_price          number;
        v_new_cat            varchar2(30);
        v_status_trim        varchar2(30);
        v_trip_type_trim     varchar2(20);
        v_from_loc_trim      varchar2(400);
        v_to_loc_trim        varchar2(400);
        v_from_place_id_trim varchar2(200);
        v_to_place_id_trim   varchar2(200);
        v_service_class_trim varchar2(50);
        v_ticket_number_trim varchar2(300);
        v_signage_trim       varchar2(300);
        v_notes_trim         varchar2(1000);
        v_request_type_trim  varchar2(50);
        v_ticket_url_trim    varchar2(4000);
        v_source_trim        varchar2(20);
        v_total_amount       number(12, 2);
        l_upd_at             timestamp;
        l_upd_by             varchar2(200);
        v_trip_type_name_ar  varchar2(100);
        v_car_type_name      varchar2(255);
        v_title_ar           varchar2(500);
        v_subtitle_ar        varchar2(1000);
        v_start_ts           timestamp;
        v_end_ts             timestamp;
        v_meta_json          clob;
    begin
        o_result.sub_res_id := null;
        o_result.main_res_id := null;
        o_result.status_message := null;
        if p_sub_res_id is null then
            o_result.status_message := 'ERROR: SUB_RES_ID is required';
            return;
        end if;
        select
            main_res_id,
            currency,
            exchange_rate,
            res_date_from,
            res_date_to,
            res_time,
            trip_price,
            cat_item_id,
            trip_type,
            from_location,
            to_location,
            from_place_id,
            to_place_id,
            service_class,
            ticket_number,
            signage_details,
            notes,
            status,
            passengers_no,
            luggage_no,
            request_type,
            ticket_url,
            source,
            order_item_id
        into
            v_main_res,
            v_curr,
            v_exrate,
            v_old_from,
            v_old_to,
            v_old_time,
            v_old_price,
            v_old_cat,
            v_old_trip,
            v_old_from_loc,
            v_old_to_loc,
            v_old_from_pid,
            v_old_to_pid,
            v_old_class,
            v_old_ticket_no,
            v_old_signage,
            v_old_notes,
            v_old_status,
            v_old_pax,
            v_old_bags,
            v_old_req,
            v_old_ticket_url,
            v_old_source,
            v_order_item_id
        from
            sublevel_limo_res
        where
                sub_res_id = p_sub_res_id
            and nvl(is_deleted, 'N') = 'N';

        order_mgmt_pkg.assert_order_is_active(v_main_res);
        if upper(nvl(v_old_status, 'X')) <> 'PENDING_ASSIGNMENT' then
            o_result.status_message := 'ERROR: CANNOT_EDIT_STATUS';
            o_result.sub_res_id := p_sub_res_id;
            o_result.main_res_id := v_main_res;
            return;
        end if;

        v_new_from := nvl(p_res_date_from, v_old_from);
        v_new_to := nvl(p_res_date_to, v_old_to);
        v_new_time := nvl(p_res_time, v_old_time);
        v_new_price := nvl(p_trip_price, v_old_price);
        v_new_cat := nvl(p_cat_item_id, v_old_cat);
        v_status_trim := trim_str(
            nvl(p_status, v_old_status),
            30
        );
        v_trip_type_trim := trim_str(
            nvl(p_trip_type, v_old_trip),
            20
        );
        v_from_loc_trim := trim_str(
            nvl(p_from_location, v_old_from_loc),
            400
        );
        v_to_loc_trim := trim_str(
            nvl(p_to_location, v_old_to_loc),
            400
        );
        v_from_place_id_trim := trim_str(
            nvl(p_from_place_id, v_old_from_pid),
            200
        );
        v_to_place_id_trim := trim_str(
            nvl(p_to_place_id, v_old_to_pid),
            200
        );
        v_service_class_trim := trim_str(
            nvl(p_service_class, v_old_class),
            50
        );
        v_ticket_number_trim := trim_str(
            nvl(p_ticket_number, v_old_ticket_no),
            300
        );
        v_signage_trim := trim_str(
            nvl(p_signage_details, v_old_signage),
            300
        );
        v_notes_trim := trim_str(
            nvl(p_notes, v_old_notes),
            1000
        );
        v_request_type_trim := trim_str(
            nvl(p_request_type, v_old_req),
            50
        );
        v_ticket_url_trim := trim_str(
            nvl(p_ticket_url, v_old_ticket_url),
            4000
        );
        v_source_trim := upper(trim_str(p_source, 20));
        if v_source_trim is null then
            o_result.status_message := 'ERROR: SOURCE is required';
            return;
        end if;
        if v_source_trim not in ( 'WEB', 'MOBILE', 'MANUAL' ) then
            o_result.status_message := 'ERROR: INVALID_SOURCE';
            return;
        end if;

        v_total_amount := calc_total_amount(v_new_price, v_new_from, v_new_to);
        order_mgmt_pkg.update_item(
            p_item_type     => 'LIMO',
            p_ref_id        => p_sub_res_id,
            p_item_status   => v_status_trim,
            p_amount_orig   => v_total_amount,
            p_currency      => v_curr,
            p_exchange_rate => v_exrate,
            o_updated_at    => l_upd_at,
            o_updated_by    => l_upd_by
        );

    /* refresh order header total */
        refresh_main_order_total(v_main_res);
        update sublevel_limo_res
        set
            cat_item_id = v_new_cat,
            trip_type = v_trip_type_trim,
            from_location = v_from_loc_trim,
            to_location = v_to_loc_trim,
            from_place_id = v_from_place_id_trim,
            to_place_id = v_to_place_id_trim,
            res_date_from = v_new_from,
            res_date_to = v_new_to,
            res_time = v_new_time,
            service_class = v_service_class_trim,
            trip_price = v_new_price,
            ticket_number = v_ticket_number_trim,
            signage_details = v_signage_trim,
            notes = v_notes_trim,
            status = v_status_trim,
            passengers_no = nvl(p_passengers_no, v_old_pax),
            luggage_no = nvl(p_luggage_no, v_old_bags),
            request_type = v_request_type_trim,
            ticket_url = v_ticket_url_trim,
            source = v_source_trim,
            updated = l_upd_at,
            updated_by = l_upd_by
        where
            sub_res_id = p_sub_res_id;

        begin
            select
                name_ar
            into v_trip_type_name_ar
            from
                limo_trip_types
            where
                trip_type_code = v_trip_type_trim;

        exception
            when no_data_found then
                v_trip_type_name_ar := v_trip_type_trim;
        end;

        begin
            select
                car_type_name
            into v_car_type_name
            from
                limo_car_types
            where
                car_type_id = v_new_cat;

        exception
            when no_data_found then
                v_car_type_name := v_new_cat;
        end;

        v_title_ar := 'ليموزين - ' || nvl(v_trip_type_name_ar, v_trip_type_trim);
        v_subtitle_ar := nvl(v_car_type_name, '-')
                         || ' - '
                         || nvl(v_from_loc_trim, '-')
                         || ' <- '
                         || nvl(v_to_loc_trim, '-');

        v_start_ts := make_ts(v_new_from, v_new_time);
        v_end_ts := cast ( trunc(nvl(v_new_to, v_new_from)) as timestamp );
        v_meta_json :=
            json_object(
                'tripTypeCode' value v_trip_type_trim,
                        'tripTypeNameAr' value v_trip_type_name_ar,
                        'carTypeId' value v_new_cat,
                        'carTypeName' value v_car_type_name,
                        'nod' value nod(v_new_from, v_new_to),
                        'ticketNumber' value v_ticket_number_trim,
                        'signage' value v_signage_trim,
                        'fromPlaceId' value v_from_place_id_trim,
                        'toPlaceId' value v_to_place_id_trim,
                        'source' value v_source_trim
            );

        order_mgmt_pkg.set_item_snapshot(
            p_order_item_id       => v_order_item_id,
            p_display_title_ar    => v_title_ar,
            p_display_subtitle_ar => v_subtitle_ar,
            p_service_start_ts    => v_start_ts,
            p_service_end_ts      => v_end_ts,
            p_meta_json           => v_meta_json
        );

        commit;
        o_result.sub_res_id := p_sub_res_id;
        o_result.main_res_id := v_main_res;
        o_result.status_message := 'SUCCESS';
    exception
        when no_data_found then
            rollback;
            o_result.status_message := 'ERROR: Reservation not found';
        when others then
            rollback;
            o_result.status_message := sqlerrm;
    end update_limo_res;

  /* =====================================================
     DELETE (soft) + cancel return child (if any)
     ===================================================== */
    procedure delete_limo_res (
        p_sub_res_id in varchar2,
        o_result     out t_result
    ) as

        v_main_res varchar2(30);
        l_upd_at   timestamp;
        l_upd_by   varchar2(200);
        cursor c_child is
        select
            sub_res_id
        from
            sublevel_limo_res
        where
                parent_sub_res_id = p_sub_res_id
            and nvl(is_deleted, 'N') = 'N'
            and status not in ( 'CANCELLED', 'COMPLETED' );

        v_child_id varchar2(30);
    begin
        o_result.sub_res_id := null;
        o_result.main_res_id := null;
        o_result.status_message := null;
        if p_sub_res_id is null then
            o_result.status_message := 'ERROR: SUB_RES_ID is required';
            return;
        end if;
        select
            main_res_id
        into v_main_res
        from
            sublevel_limo_res
        where
                sub_res_id = p_sub_res_id
            and nvl(is_deleted, 'N') = 'N';

        order_mgmt_pkg.assert_order_is_active(v_main_res);
        order_mgmt_pkg.cancel_item(
            p_item_type  => 'LIMO',
            p_ref_id     => p_sub_res_id,
            o_updated_at => l_upd_at,
            o_updated_by => l_upd_by
        );

        update sublevel_limo_res
        set
            status = 'CANCELLED',
            is_deleted = 'Y',
            deleted = l_upd_at,
            deleted_by = l_upd_by,
            updated = l_upd_at,
            updated_by = l_upd_by
        where
            sub_res_id = p_sub_res_id;

        open c_child;
        loop
            fetch c_child into v_child_id;
            exit when c_child%notfound;
            begin
                order_mgmt_pkg.cancel_item(
                    p_item_type  => 'LIMO',
                    p_ref_id     => v_child_id,
                    o_updated_at => l_upd_at,
                    o_updated_by => l_upd_by
                );
            exception
                when others then
                    null;
            end;

            update sublevel_limo_res
            set
                status = 'CANCELLED',
                is_deleted = 'Y',
                deleted = l_upd_at,
                deleted_by = l_upd_by,
                updated = l_upd_at,
                updated_by = l_upd_by
            where
                sub_res_id = v_child_id;

        end loop;

        close c_child;

    /* refresh order header total */
        refresh_main_order_total(v_main_res);
        commit;
        o_result.sub_res_id := p_sub_res_id;
        o_result.main_res_id := v_main_res;
        o_result.status_message := 'SUCCESS';
    exception
        when no_data_found then
            rollback;
            o_result.status_message := 'ERROR: Reservation not found';
        when others then
            rollback;
            o_result.status_message := sqlerrm;
    end delete_limo_res;

  /* =====================================================
     RETURN
     ===================================================== */
    procedure create_return_res (
        p_parent_sub_res_id in varchar2,
        p_res_date          in date,
        p_res_time          in varchar2,
        p_trip_price        in number,
        p_return_status     in varchar2 default 'CONFIRMED',
        o_sub_res_id        out varchar2
    ) is

        v_parent        sublevel_limo_res%rowtype;
        v_main_res_id   varchar2(30);
        v_sub_res_id    varchar2(30);
        v_from          varchar2(400);
        v_to            varchar2(400);
        v_from_place_id varchar2(200);
        v_to_place_id   varchar2(200);
        l_res           t_result;
    begin
        o_sub_res_id := null;
        select
            *
        into v_parent
        from
            sublevel_limo_res
        where
                sub_res_id = p_parent_sub_res_id
            and nvl(is_deleted, 'N') = 'N';

        if upper(nvl(v_parent.status, 'X')) = 'CANCELLED' then
            raise_application_error(-20002, 'Parent trip is cancelled');
        end if;

        if p_res_date is null then
            raise_application_error(-20003, 'Return date is required');
        end if;
        v_from := v_parent.to_location;
        v_to := v_parent.from_location;
        v_from_place_id := v_parent.to_place_id;
        v_to_place_id := v_parent.from_place_id;
        v_main_res_id := v_parent.main_res_id;
        v_sub_res_id := null;
        create_limo_res(
            p_main_res_id     => v_main_res_id,
            p_sub_res_id      => v_sub_res_id,
            p_customer_id     => null,
            p_trip_type       => v_parent.trip_type,
            p_from_location   => v_from,
            p_to_location     => v_to,
            p_from_place_id   => v_from_place_id,
            p_to_place_id     => v_to_place_id,
            p_currency        => v_parent.currency,
            p_exchange_rate   => v_parent.exchange_rate,
            p_ticket_number   => v_parent.ticket_number,
            p_signage_details => v_parent.signage_details,
            p_notes           => v_parent.notes,
            p_status          => 'PENDING_ASSIGNMENT',
            p_cat_item_id     => v_parent.cat_item_id,
            p_res_date_from   => p_res_date,
            p_res_date_to     => p_res_date,
            p_res_time        => p_res_time,
            p_service_class   => v_parent.service_class,
            p_trip_price      => p_trip_price,
            p_ticket_url      => v_parent.ticket_url,
            p_source          => v_parent.source,
            p_passengers_no   => v_parent.passengers_no,
            p_luggage_no      => v_parent.luggage_no,
            p_request_type    => v_parent.request_type,
            o_result          => l_res
        );

        if l_res.status_message <> 'SUCCESS'
        or v_sub_res_id is null then
            raise_application_error(-20020,
                                    'Return create failed: '
                                    || nvl(l_res.status_message, 'UNKNOWN'));
        end if;

        update sublevel_limo_res
        set
            parent_sub_res_id = p_parent_sub_res_id,
            return_type = 'RETURN',
            return_status = nvl(p_return_status, 'CONFIRMED'),
            return_confirmed_at =
                case
                    when nvl(p_return_status, 'CONFIRMED') = 'CONFIRMED' then
                        systimestamp
                end
        where
            sub_res_id = v_sub_res_id;

        update sublevel_limo_res
        set
            return_type = nvl(return_type, 'OUTBOUND')
        where
            sub_res_id = p_parent_sub_res_id;

        o_sub_res_id := v_sub_res_id;
    exception
        when no_data_found then
            raise_application_error(-20010, 'Parent trip not found');
        when others then
            raise_application_error(-20099, 'create_return_res failed: ' || sqlerrm);
    end create_return_res;

end l_reservation_pkg;
/

