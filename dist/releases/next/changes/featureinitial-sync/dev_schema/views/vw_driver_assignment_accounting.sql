-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464127579 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_driver_assignment_accounting.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_driver_assignment_accounting.sql:null:0c48836b766f0ecca8d374af6dc55e4a0abf740d:create

create or replace force editionable view vw_driver_assignment_accounting (
    assignment_end_date,
    assignment_id,
    assignment_note,
    product_id,
    reservation_id,
    assignment_type,
    driver_id,
    driver_name,
    assignment_type_ar,
    driver_share_type,
    driver_share_value,
    currency,
    product_currency,
    driver_status,
    created_at,
    collection_note,
    driver_avatar,
    share_display,
    share_type_ar,
    share_percent_value,
    trips_made,
    total_trips_amount,
    total_trips_amount_egp,
    driver_total_payout_egp,
    office_net_egp,
    total_expenses_egp,
    total_added_services_egp,
    total_collected_egp,
    collections_by_currency_json
) as
    with trip_stats as (
        select
            ta.assignment_id,
            count(*)     as trips_made,
            nvl(
                max(p.price),
                0
            ) * count(*) as total_trips_amount,
            round(nvl(
                max(p.price),
                0
            ) * count(*) * nvl(
                max(p.exchange_rate),
                1
            ),
                  2)     as total_trips_amount_egp,
            round(
                sum(ta.total_driver_payout_egp),
                2
            )            as driver_total_payout_egp,
            round(
                sum(ta.office_net_egp),
                2
            )            as office_net_egp,
            round(
                sum(ta.trip_expenses_egp),
                2
            )            as total_expenses_egp,
            round(
                sum(ta.added_services_egp),
                2
            )            as total_added_services_egp,
            round(
                sum(ta.paid_amount_egp),
                2
            )            as total_collected_egp
        from
                 vw_limo_trip_accounting ta
            join limo_products p on ta.product_id = p.product_id
        group by
            ta.assignment_id
    ), collections_json as (
        select
            x.assignment_id,
            json_arrayagg(
                json_object(
                    'currency' value x.currency,
                            'amount' value to_char(x.total_amount, '999G999G990D00'),
                            'amount_egp' value to_char(x.total_amount_egp, '999G999G990D00')
                )
            returning clob) as collections_by_currency_json
        from
            (
                select
                    c.assignment_id,
                    c.currency,
                    sum(c.amount_collected)                                as total_amount,
                    sum(c.amount_collected * nvl(c.exchange_rate_used, 1)) as total_amount_egp
                from
                    limo_trip_collections c
                where
                    c.collected_by_type = 'DRIVER'
                group by
                    c.assignment_id,
                    c.currency
            ) x
        group by
            x.assignment_id
    )
    select
    -- Assignment End Date (from Product)
        (
            select
                p.trip_date_to
            from
                limo_products p
            where
                p.product_id = a.product_id
        )                                                 as assignment_end_date,
        a.assignment_id,
        a.notes                                           as assignment_note,
        a.product_id,
        a.reservation_id,
        a.assignment_type,
        a.driver_id,
    -- Driver Name
        case a.assignment_type
            when 'INSOURCE'  then
                nvl(cd.driver_name, 'غير معروف')
            when 'OUTSOURCE' then
                nvl(s.supplier_name, 'غير معروف')
            else
                'غير معروف'
        end                                               as driver_name,
        nvl(t.assignment_type_name_ar, a.assignment_type) as assignment_type_ar,
        a.driver_share_type,
        a.driver_share_value,
        a.currency,
    -- Product Currency
        (
            select
                p.currency
            from
                limo_products p
            where
                p.product_id = a.product_id
        )                                                 as product_currency,
    -- Arabic Driver Status
        case a.driver_status
            when 'CURRENT'  then
                'حالي'
            when 'PREVIOUS' then
                'سابق'
            else
                a.driver_status
        end                                               as driver_status,
        to_char(a.created, 'DD/MM/YYYY HH24:MI')          as created_at,
    -- Collection Policy Note
        case
            when a.direct_collect_by_driver_yn = 'Y' then
                'تحصيل تلقائي من السائق عند انتهاء الرحلة'
        end                                               as collection_note,
    -- Driver Avatar
        case a.assignment_type
            when 'INSOURCE'  then
                    case
                        when cd.photo_url is not null then
                            cd.photo_url
                        else
                            'https://g84c211b3b16868-apexadb1.adb.me-jeddah-1.oraclecloudapps.com/ords/r/blitzlayali333/135/files/static/v282/placeholders/unknown.png'
                    end
            when 'OUTSOURCE' then
                    case
                        when s.photo_url is not null then
                            s.photo_url
                        else
                            'https://g84c211b3b16868-apexadb1.adb.me-jeddah-1.oraclecloudapps.com/ords/r/blitzlayali333/135/files/static/v282/placeholders/unknown.png'
                    end
            else
                'https://g84c211b3b16868-apexadb1.adb.me-jeddah-1.oraclecloudapps.com/ords/r/blitzlayali333/135/files/static/v282/placeholders/unknown.png'
        end                                               as driver_avatar,
    -- Share display
        case a.driver_share_type
            when 'FIXED'   then
                to_char(a.driver_share_value)
                || ' '
                || a.currency
            when 'PERCENT' then
                to_char(a.driver_share_value)
                || '%'
            else
                to_char(a.driver_share_value)
        end                                               as share_display,
    -- Share type Arabic
        case a.driver_share_type
            when 'FIXED'   then
                'مبلغ ثابت'
            when 'PERCENT' then
                'نسبة'
            else
                a.driver_share_type
        end                                               as share_type_ar,
    -- Share percent bar
        case
            when a.driver_share_type = 'PERCENT' then
                a.driver_share_value
        end                                               as share_percent_value,
    -- Trip stats from CTE
        ts.trips_made,
        ts.total_trips_amount,
        ts.total_trips_amount_egp,
        ts.driver_total_payout_egp,
        ts.office_net_egp,
        ts.total_expenses_egp,
        ts.total_added_services_egp,
        ts.total_collected_egp,
        cj.collections_by_currency_json
    from
        limo_product_assignments a
        left join suppliers                s on a.assignment_type = 'OUTSOURCE'
                                 and s.supplier_id = a.driver_id
        left join company_drivers          cd on a.assignment_type = 'INSOURCE'
                                        and cd.driver_id = a.driver_id
        left join limo_assignment_types    t on t.assignment_type_code = a.assignment_type
        left join trip_stats               ts on a.assignment_id = ts.assignment_id
        left join collections_json         cj on a.assignment_id = cj.assignment_id;

