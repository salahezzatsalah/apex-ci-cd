create or replace package body ft_reservation_pkg as

  /* ================================
     helpers
     ================================ */
    function trim_str (
        p_val varchar2,
        p_len pls_integer
    ) return varchar2 is
    begin
        return substr(p_val, 1, p_len);
    end;

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

  /* =====================================================
     CREATE
     ===================================================== */
    procedure create_fast_track_res (
        p_main_res_id      in out varchar2,
        p_customer_id      in varchar2,
        p_cat_item_id      in varchar2,
        p_res_date         in date,
        p_res_time         in varchar2,
        p_airport_id       in varchar2,
        p_terminal_no      in varchar2,
        p_ticket_url       in varchar2,
        p_passengers_no    in number,
        p_passengers_info  in clob,
        p_currency         in varchar2,
        p_exchange_rate    in number,
        p_service_class    in varchar2,
        p_price_per_person in number,
        p_signage_details  in varchar2,
        p_notes            in varchar2,
        p_status           in varchar2,
        o_result           out t_result
    ) as

        v_sub_res_id    varchar2(30);
        v_order_item_id varchar2(30); -- FK
        v_total_amt     number(12, 2);

    /* lifecycle values must come from ORDER_MGMT_PKG */
        l_created_at    timestamp;
        l_created_by    varchar2(200);
        l_extension     varchar2(20);
        l_object_name   varchar2(4000);
        l_public_url    varchar2(4000);

    /* snapshot vars */
        v_service_name  varchar2(200);
        v_airport_name  varchar2(255);
        v_title_ar      varchar2(500);
        v_subtitle_ar   varchar2(1000);
        v_start_ts      timestamp;
        v_meta_json     clob;

    /* trims */
        v_terminal_trim varchar2(20);
        v_signage_trim  varchar2(300);
        v_notes_trim    varchar2(1000);
        v_status_trim   varchar2(50);
        v_class_trim    varchar2(50);
    begin
        o_result.sub_res_id := null;
        o_result.main_res_id := null;
        o_result.status_message := null;

    /* 0) Resolve active order */
        if p_main_res_id is null then
            if p_customer_id is null then
                o_result.status_message := 'ERROR: CUSTOMER_ID is required when MAIN_RES_ID is NULL';
                return;
            end if;
            p_main_res_id := order_mgmt_pkg.get_or_create_active_order(
                p_customer_id => p_customer_id,
                p_currency    => p_currency
            );
        end if;

        order_mgmt_pkg.assert_order_is_active(p_main_res_id);

    /* Guards */
        if p_cat_item_id is null
           or p_res_date is null
        or p_passengers_no is null then
            o_result.status_message := 'ERROR: Missing required fields';
            return;
        end if;

    /* 1) Generate IDs + amount */
        v_sub_res_id := 'FT-'
                        || lpad(seq_subft_sub_res.nextval, 6, '0');
        v_total_amt := nvl(p_passengers_no, 0) * nvl(p_price_per_person, 0);

    /* trims */
        v_terminal_trim := trim_str(p_terminal_no, 20);
        v_signage_trim := trim_str(p_signage_details, 300);
        v_notes_trim := trim_str(p_notes, 1000);
        v_status_trim := trim_str(
            nvl(p_status, 'PENDING_ASSIGNMENT'),
            50
        );
        v_class_trim := trim_str(p_service_class, 50);

    /* 2) Register item in OMS FIRST */
        order_mgmt_pkg.add_item(
            p_main_res_id   => p_main_res_id,
            p_item_type     => 'FAST_TRACK',
            p_ref_table     => 'SUBLEVEL_FAST_TRACK_RES',
            p_ref_id        => v_sub_res_id,
            p_item_status   => v_status_trim,
            p_amount_orig   => v_total_amt,
            p_currency      => p_currency,
            p_exchange_rate => p_exchange_rate,
            o_order_item_id => v_order_item_id,
            o_created_at    => l_created_at,
            o_created_by    => l_created_by
        );

    /* 3) Insert sub reservation */
        insert into sublevel_fast_track_res (
            sub_res_id,
            order_item_id,
            main_res_id,
            cat_item_id,
            res_date,
            res_time,
            airport_id,
            terminal_no,
            ticket_url,
            passengers_no,
            passengers_info,
            currency,
            exchange_rate,
            service_class,
            price_per_person,
            total_amount,
            status,
            signage_details,
            notes,
            created,
            created_by
        ) values ( v_sub_res_id,
                   v_order_item_id,
                   p_main_res_id,
                   p_cat_item_id,
                   p_res_date,
                   p_res_time,
                   p_airport_id,
                   v_terminal_trim,
                   p_ticket_url,
                   p_passengers_no,
                   p_passengers_info,
                   p_currency,
                   p_exchange_rate,
                   v_class_trim,
                   p_price_per_person,
                   v_total_amt,
                   v_status_trim,
                   v_signage_trim,
                   v_notes_trim,
                   l_created_at,
                   l_created_by );

    /* =====================================================
       SNAPSHOT (FAST TRACK)
       - title: ✈️ فاست تراك • {service name}
       - subtitle: {airport} • صالة {terminal} • {pax} ركاب
       ===================================================== */

    /* service name */
        begin
            select
                service_name
            into v_service_name
            from
                fast_track_service_catalog
            where
                service_id = p_cat_item_id;

        exception
            when no_data_found then
                v_service_name := p_cat_item_id;
        end;

    /* airport name */
        begin
            select
                airport_name
            into v_airport_name
            from
                airports
            where
                airport_id = p_airport_id;

        exception
            when no_data_found then
                v_airport_name := null;
        end;

        v_title_ar := '✈️ فاست تراك • ' || nvl(v_service_name, 'خدمة');
        v_subtitle_ar := nvl(v_airport_name, '-')
                         ||
            case
                when v_terminal_trim is not null then
                    ' • صالة ' || v_terminal_trim
                else
                    ''
            end
                         || ' • '
                         || nvl(
            to_char(p_passengers_no),
            '0'
        )
                         || ' ركاب';

        v_start_ts := make_ts(p_res_date, p_res_time);
        v_meta_json :=
            json_object(
                'serviceId' value p_cat_item_id,
                'serviceName' value v_service_name,
                'airportId' value p_airport_id,
                'airportName' value v_airport_name,
                'terminal' value v_terminal_trim,
                        'pax' value p_passengers_no,
                'signage' value v_signage_trim,
                'serviceClass' value v_class_trim
            );

        order_mgmt_pkg.set_item_snapshot(
            p_order_item_id       => v_order_item_id,
            p_display_title_ar    => v_title_ar,
            p_display_subtitle_ar => v_subtitle_ar,
            p_service_start_ts    => v_start_ts,
            p_meta_json           => v_meta_json
        );

    /* =====================================================
       Ticket uploads (keep your existing logic)
       ===================================================== */
        if p_ticket_url is not null then
            declare
                l_file_names  apex_t_varchar2;
                l_file        apex_application_temp_files%rowtype;
                l_public_urls apex_t_varchar2 := apex_t_varchar2();
                l_temp_name   varchar2(4000);
                l_attach_id   raw(16);
                l_json        clob;
                l_item        varchar2(4000);
                l_upd_at      timestamp;
                l_upd_by      varchar2(200);
            begin
                l_file_names := apex_string.split(p_ticket_url, ':');
                for i in 1..l_file_names.count loop
                    l_temp_name := trim(l_file_names(i));
                    if l_temp_name is null then
                        continue;
                    end if;
                    begin
                        select
                            blob_content,
                            filename,
                            mime_type
                        into
                            l_file.blob_content,
                            l_file.filename,
                            l_file.mime_type
                        from
                            apex_application_temp_files
                        where
                            name = l_temp_name;

                        l_extension := lower(nvl(
                            regexp_substr(l_file.filename, '\.[[:alnum:]]+$'),
                            '.jpg'
                        ));

                        l_object_name := 'TICKETS_FILES/'
                                         || p_main_res_id
                                         || '/'
                                         || v_sub_res_id
                                         || '/'
                                         || v_sub_res_id
                                         || '_'
                                         || i
                                         || l_extension;

                        drive_crud_api.set_bucket(app_config.g_default_bucket);
                        drive_crud_api.upload_file(
                            p_parent_name => 'TICKETS_FILES/'
                                             || p_main_res_id
                                             || '/'
                                             || v_sub_res_id,
                            p_filename    => v_sub_res_id
                                          || '_'
                                          || i
                                          || l_extension,
                            p_blob        => l_file.blob_content
                        );

                        l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                        || drive_crud_api.create_par(
                            p_object_name  => l_object_name,
                            p_par_name     => 'ticket-'
                                          || v_sub_res_id
                                          || '-'
                                          || i
                                          || '-par',
                            p_time_expires => add_months(systimestamp, 12)
                        );

                        l_public_urls.extend;
                        l_public_urls(l_public_urls.count) := l_public_url;
                        begin
                            l_attach_id := sys_guid();
                            insert into sublevel_attachments (
                                attach_id,
                                sub_res_id,
                                filename,
                                object_name,
                                public_url,
                                mime_type,
                                created_by
                            ) values ( l_attach_id,
                                       v_sub_res_id,
                                       l_file.filename,
                                       l_object_name,
                                       l_public_url,
                                       l_file.mime_type,
                                       l_created_by );

                        exception
                            when others then
                                null;
                        end;

                    exception
                        when others then
                            l_public_urls.extend;
                            l_public_urls(l_public_urls.count) := 'ERROR:'
                                                                  || l_temp_name
                                                                  || ':'
                                                                  || sqlerrm;

                    end;

                end loop;

        /* build json array */
                l_json := '[';
                for j in 1..l_public_urls.count loop
                    if j > 1 then
                        l_json := l_json || ',';
                    end if;
                    l_item := l_public_urls(j);
                    l_json := l_json
                              || '"'
                              || replace(l_item, '"', '\"')
                              || '"';

                end loop;

                l_json := l_json || ']';

        /* OMS update generates UPDATED/UPDATED_BY */
                order_mgmt_pkg.update_item(
                    p_item_type     => 'FAST_TRACK',
                    p_ref_id        => v_sub_res_id,
                    p_item_status   => v_status_trim,
                    p_amount_orig   => v_total_amt,
                    p_currency      => p_currency,
                    p_exchange_rate => p_exchange_rate,
                    o_updated_at    => l_upd_at,
                    o_updated_by    => l_upd_by
                );

                update sublevel_fast_track_res
                set
                    ticket_url = l_json,
                    updated = l_upd_at,
                    updated_by = l_upd_by
                where
                    sub_res_id = v_sub_res_id;

            end;
        end if;

        commit;
        o_result.sub_res_id := v_sub_res_id;
        o_result.main_res_id := p_main_res_id;
        o_result.status_message := 'SUCCESS';
    exception
        when others then
            rollback;
            o_result.sub_res_id := v_sub_res_id;
            o_result.main_res_id := p_main_res_id;
            o_result.status_message := sqlerrm;
    end create_fast_track_res;

  /* =====================================================
     UPDATE
     ===================================================== */
    procedure update_fast_track_res (
        p_sub_res_id       in varchar2,
        p_cat_item_id      in varchar2,
        p_service_class    in varchar2,
        p_res_date         in date,
        p_res_time         in varchar2,
        p_airport_id       in varchar2,
        p_terminal_no      in varchar2,
        p_passengers_no    in number,
        p_passengers_info  in clob,
        p_price_per_person in number,
        p_signage_details  in varchar2,
        p_notes            in varchar2,
        p_status           in varchar2,
        o_result           out t_result
    ) as

        v_total_amt     number(12, 2);
        v_main_res      varchar2(30);
        v_curr          varchar2(10);
        v_exrate        number(18, 10);
        v_order_item_id varchar2(30);
        l_upd_at        timestamp;
        l_upd_by        varchar2(200);

    /* snapshot vars */
        v_service_name  varchar2(200);
        v_airport_name  varchar2(255);
        v_title_ar      varchar2(500);
        v_subtitle_ar   varchar2(1000);
        v_start_ts      timestamp;
        v_meta_json     clob;
        v_terminal_trim varchar2(20);
        v_signage_trim  varchar2(300);
        v_notes_trim    varchar2(1000);
        v_status_trim   varchar2(50);
        v_class_trim    varchar2(50);
    begin
        o_result.sub_res_id := null;
        o_result.main_res_id := null;
        o_result.status_message := null;
        if p_sub_res_id is null then
            o_result.status_message := 'ERROR: SUB_RES_ID is required';
            return;
        end if;
        v_total_amt := nvl(p_passengers_no, 0) * nvl(p_price_per_person, 0);
        v_terminal_trim := trim_str(p_terminal_no, 20);
        v_signage_trim := trim_str(p_signage_details, 300);
        v_notes_trim := trim_str(p_notes, 1000);
        v_status_trim := trim_str(
            nvl(p_status, 'PENDING_ASSIGNMENT'),
            50
        );
        v_class_trim := trim_str(p_service_class, 50);
        update sublevel_fast_track_res
        set
            cat_item_id = p_cat_item_id,
            service_class = v_class_trim,
            res_date = p_res_date,
            res_time = p_res_time,
            airport_id = p_airport_id,
            terminal_no = v_terminal_trim,
            passengers_no = p_passengers_no,
            passengers_info = p_passengers_info,
            price_per_person = p_price_per_person,
            total_amount = v_total_amt,
            signage_details = v_signage_trim,
            notes = v_notes_trim,
            status = v_status_trim
        where
            sub_res_id = p_sub_res_id;

        if sql%rowcount = 0 then
            rollback;
            o_result.status_message := 'ERROR: Reservation not found';
            return;
        end if;

        select
            main_res_id,
            currency,
            exchange_rate,
            order_item_id
        into
            v_main_res,
            v_curr,
            v_exrate,
            v_order_item_id
        from
            sublevel_fast_track_res
        where
            sub_res_id = p_sub_res_id;

        order_mgmt_pkg.update_item(
            p_item_type     => 'FAST_TRACK',
            p_ref_id        => p_sub_res_id,
            p_item_status   => v_status_trim,
            p_amount_orig   => v_total_amt,
            p_currency      => v_curr,
            p_exchange_rate => v_exrate,
            o_updated_at    => l_upd_at,
            o_updated_by    => l_upd_by
        );

        update sublevel_fast_track_res
        set
            updated = l_upd_at,
            updated_by = l_upd_by
        where
            sub_res_id = p_sub_res_id;

    /* snapshot rebuild */
        begin
            select
                service_name
            into v_service_name
            from
                fast_track_service_catalog
            where
                service_id = p_cat_item_id;

        exception
            when no_data_found then
                v_service_name := p_cat_item_id;
        end;

        begin
            select
                airport_name
            into v_airport_name
            from
                airports
            where
                airport_id = p_airport_id;

        exception
            when no_data_found then
                v_airport_name := null;
        end;

        v_title_ar := '✈️ فاست تراك • ' || nvl(v_service_name, 'خدمة');
        v_subtitle_ar := nvl(v_airport_name, '-')
                         ||
            case
                when v_terminal_trim is not null then
                    ' • صالة ' || v_terminal_trim
                else
                    ''
            end
                         || ' • '
                         || nvl(
            to_char(p_passengers_no),
            '0'
        )
                         || ' ركاب';

        v_start_ts := make_ts(p_res_date, p_res_time);
        v_meta_json :=
            json_object(
                'serviceId' value p_cat_item_id,
                'serviceName' value v_service_name,
                'airportId' value p_airport_id,
                'airportName' value v_airport_name,
                'terminal' value v_terminal_trim,
                        'pax' value p_passengers_no,
                'signage' value v_signage_trim,
                'serviceClass' value v_class_trim
            );

        order_mgmt_pkg.set_item_snapshot(
            p_order_item_id       => v_order_item_id,
            p_display_title_ar    => v_title_ar,
            p_display_subtitle_ar => v_subtitle_ar,
            p_service_start_ts    => v_start_ts,
            p_meta_json           => v_meta_json
        );

        commit;
        o_result.sub_res_id := p_sub_res_id;
        o_result.main_res_id := v_main_res;
        o_result.status_message := 'SUCCESS';
    exception
        when others then
            rollback;
            o_result.sub_res_id := p_sub_res_id;
            o_result.main_res_id := v_main_res;
            o_result.status_message := sqlerrm;
    end update_fast_track_res;

  /* =====================================================
     DELETE (soft)
     ===================================================== */
    procedure delete_fast_track_res (
        p_sub_res_id in varchar2,
        o_result     out t_result
    ) as
        v_main_res varchar2(30);
        l_upd_at   timestamp;
        l_upd_by   varchar2(200);
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
            sublevel_fast_track_res
        where
            sub_res_id = p_sub_res_id;

        update sublevel_fast_track_res
        set
            status = 'CANCELLED',
            is_deleted = 'Y',
            deleted = systimestamp,
            deleted_by = nvl(
                apex_util.get_session_state('APP_USER_ID'),
                'SYSTEM'
            )
        where
            sub_res_id = p_sub_res_id;

        order_mgmt_pkg.cancel_item(
            p_item_type  => 'FAST_TRACK',
            p_ref_id     => p_sub_res_id,
            o_updated_at => l_upd_at,
            o_updated_by => l_upd_by
        );

        update sublevel_fast_track_res
        set
            updated = l_upd_at,
            updated_by = l_upd_by
        where
            sub_res_id = p_sub_res_id;

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
    end delete_fast_track_res;

end ft_reservation_pkg;
/


-- sqlcl_snapshot {"hash":"8d9d9dc29fca1c504c669b46df5a893c04a31eea","type":"PACKAGE_BODY","name":"FT_RESERVATION_PKG","schemaName":"DEV_SCHEMA","sxml":""}