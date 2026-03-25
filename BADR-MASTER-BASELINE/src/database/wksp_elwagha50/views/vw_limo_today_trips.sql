create or replace force editionable view vw_limo_today_trips (
    trip_index,
    client_id,
    classification_type,
    product_status,
    reservation_id,
    product_id,
    client_name,
    client_phone,
    requested_car,
    pick_up_time,
    product_price,
    product_currency,
    from_location,
    to_location,
    ticket_number,
    signage_details,
    driver_assignment_value,
    driver_assignment_label,
    trip_notes,
    number_of_days,
    trip_date_from,
    trip_date_to,
    trips_count,
    last_trip_id,
    last_trip_status,
    driver_phone,
    assignment_id,
    has_fast_track_reservation_today,
    assignmentnotes
) as
    select
  /* ===============================
     Index
     =============================== */
        row_number()
        over(
            order by
                convert_to_local_timezone(sl.res_date_from),
                to_date(normalize_time(sl.res_time),
                           'HH24:MI'),
                sl.created
        )                              as trip_index,

  /* ===============================
     Client & classification
     =============================== */
        mr.customer_id                 as client_id,
        cl.classification_label_ar     as classification_type,

  /* ===============================
     Product / reservation identity
     =============================== */
        sl.status                      as product_status,
        mr.main_res_id                 as reservation_id,
        sl.sub_res_id                  as product_id,
        c.client_code                  as client_name,
        cc.contact_value               as client_phone,

  /* ===============================
     Requested car
     =============================== */
        nvl(ct.car_type_name, '-')
        || ' / '
        || nvl(tt.name_ar, 'غير محدد') as requested_car,

  /* ===============================
     Pickup datetime
     =============================== */
        to_char(to_date(to_char(
            convert_to_local_timezone(sl.res_date_from),
            'DD/MM/YYYY'
        )
                        || ' '
                        || normalize_time(sl.res_time),
                'DD/MM/YYYY HH24:MI'),
                'DD/MM/YYYY HH24:MI')  as pick_up_time,

  /* ===============================
     Pricing
     =============================== */
        sl.trip_price                  as product_price,
        sl.currency                    as product_currency,
        sl.from_location,
        sl.to_location,
        sl.ticket_number,
        sl.signage_details,

  /* ===============================
     Driver assignment value
     =============================== */
        case
            when not exists (
                select
                    1
                from
                    limo_product_assignments a
                where
                        a.reservation_id = mr.main_res_id
                    and a.product_id = sl.sub_res_id
                    and a.driver_status = 'CURRENT'
            ) then
                'في انتظار التوزيع'
            else
                (
                    select
                        case a.assignment_type
                            when 'INSOURCE'  then
                                d.driver_name
                            when 'OUTSOURCE' then
                                s.supplier_name
                            else
                                'غير معروف'
                        end
                    from
                        limo_product_assignments a
                        left join company_drivers          d on a.assignment_type = 'INSOURCE'
                                                       and d.driver_id = a.driver_id
                        left join suppliers                s on a.assignment_type = 'OUTSOURCE'
                                                 and to_char(s.supplier_id) = a.driver_id
                    where
                            a.reservation_id = mr.main_res_id
                        and a.product_id = sl.sub_res_id
                        and a.driver_status = 'CURRENT'
                    order by
                        a.created desc
                    fetch first 1 rows only
                )
        end                            as driver_assignment_value,

  /* ===============================
     Driver label
     =============================== */
        case
            when not exists (
                select
                    1
                from
                    limo_product_assignments a
                where
                        a.reservation_id = mr.main_res_id
                    and a.product_id = sl.sub_res_id
                    and a.driver_status = 'CURRENT'
            ) then
                'حالة التوزيع:'
            else
                'السائق الحالي:'
        end                            as driver_assignment_label,

  /* ===============================
     Trip notes & dates
     =============================== */
        sl.notes                       as trip_notes,
        sl.nod                         as number_of_days,
        sl.res_date_from               as trip_date_from,
        sl.res_date_to                 as trip_date_to,

  /* ===============================
     Trips count & last trip
     =============================== */
        (
            select
                count(*)
            from
                limo_trips_tracker_v2 t
            where
                t.product_id = sl.sub_res_id
        )                              as trips_count,
        (
            select
                trip_id
            from
                (
                    select
                        trip_id,
                        row_number()
                        over(partition by sub_res_id
                             order by
                                 start_datetime desc
                        ) rn
                    from
                        limo_trips_tracker_v2
                    where
                        sub_res_id = sl.sub_res_id
                )
            where
                rn = 1
        )                              as last_trip_id,
        (
            select
                status
            from
                (
                    select
                        status,
                        row_number()
                        over(partition by sub_res_id
                             order by
                                 start_datetime desc
                        ) rn
                    from
                        limo_trips_tracker_v2
                    where
                        sub_res_id = sl.sub_res_id
                )
            where
                rn = 1
        )                              as last_trip_status,

  /* ===============================
     Driver phone
     =============================== */
        (
            select
                case a.assignment_type
                    when 'INSOURCE'  then
                        d.phone
                    when 'OUTSOURCE' then
                        s.phone
                end
            from
                limo_product_assignments a
                left join company_drivers          d on a.assignment_type = 'INSOURCE'
                                               and d.driver_id = a.driver_id
                left join suppliers                s on a.assignment_type = 'OUTSOURCE'
                                         and to_char(s.supplier_id) = a.driver_id
            where
                    a.reservation_id = mr.main_res_id
                and a.product_id = sl.sub_res_id
                and a.driver_status = 'CURRENT'
            order by
                a.created desc
            fetch first 1 rows only
        )                              as driver_phone,

  /* ===============================
     Assignment ID
     =============================== */
        (
            select
                a.assignment_id
            from
                limo_product_assignments a
            where
                    a.reservation_id = mr.main_res_id
                and a.product_id = sl.sub_res_id
                and a.driver_status = 'CURRENT'
            order by
                a.created desc
            fetch first 1 rows only
        )                              as assignment_id,

  /* ===============================
     Fast track today flag
     =============================== */
        case
            when exists (
                select
                    1
                from
                    sublevel_fast_track_res ft
                where
                        ft.main_res_id = mr.main_res_id
                    and trunc(ft.res_date) = trunc(sysdate)
            ) then
                1
            else
                0
        end                            as has_fast_track_reservation_today,

  /* ===============================
     Assignment notes
     =============================== */
        (
            select
                a.notes
            from
                limo_product_assignments a
            where
                    a.reservation_id = mr.main_res_id
                and a.product_id = sl.sub_res_id
                and a.driver_status = 'CURRENT'
            order by
                a.created desc
            fetch first 1 rows only
        )                              as assignmentnotes
    from
             sublevel_limo_res sl
        join main_reservations          mr on mr.main_res_id = sl.main_res_id
        join clients                    c on mr.customer_id = c.client_id
        left join client_contacts            cc on cc.client_id = c.client_id
                                        and cc.contact_type = 'PHONE'
                                        and cc.is_primary = 'Y'
        left join limo_car_types             ct on sl.cat_item_id = ct.car_type_id
        left join limo_trip_types            tt on sl.trip_type = tt.trip_type_code
        left join limo_classifications_types cl on sl.service_class = cl.classification_code
    where
        trunc(convert_to_local_timezone(sl.res_date_from)) = trunc(convert_to_local_timezone(sysdate));


-- sqlcl_snapshot {"hash":"65e178eaeb19d2dfbbc715da25042d2fd60d0c29","type":"VIEW","name":"VW_LIMO_TODAY_TRIPS","schemaName":"WKSP_ELWAGHA50","sxml":""}