-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464135950 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_limo_trip_accounting.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_limo_trip_accounting.sql:null:c808ee4c525567f198b728aa1bb9eee4b98510dc:create

create or replace force editionable view vw_limo_trip_accounting (
    trip_id,
    product_id,
    assignment_id,
    start_datetime,
    end_datetime,
    base_price_currency,
    trip_currency,
    exchange_rate,
    base_price_egp,
    added_services_egp,
    added_services_currency,
    trip_expenses_egp,
    revenue_after_expenses_egp,
    driver_share_type,
    driver_share_value,
    driver_name,
    driver_share_from_trip_egp,
    driver_share_from_services_egp,
    total_invoice_egp,
    total_invoice_currency,
    total_driver_payout_egp,
    office_net_egp,
    office_net_currency,
    paid_amount_egp,
    paid_amount_orig_curr,
    outstanding_amount_egp,
    outstanding_amount_orig_curr
) as
    select
        t.trip_id,
        t.product_id,
        t.assignment_id,
        t.start_datetime,
        t.end_datetime,

    -- ✅ Base Price
        p.price                             as base_price_currency,
        p.currency                          as trip_currency,
        p.exchange_rate,
        round(p.price * nvl(p.exchange_rate, 1),
              2)                            as base_price_egp,

    -- ✅ Added Services
        nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
            0)                              as added_services_egp,
        nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
            0) / nullif(p.exchange_rate, 0) as added_services_currency,

    -- ✅ Trip Expenses
        nvl((
            select
                sum(e.amount)
            from
                limo_trip_expenses e
            where
                e.trip_id = t.trip_id
        ),
            0)                              as trip_expenses_egp,

    -- ✅ Revenue After Expenses (only base - expenses)
        round((p.price * nvl(p.exchange_rate, 1)) - nvl((
            select
                sum(e.amount)
            from
                limo_trip_expenses e
            where
                e.trip_id = t.trip_id
        ),
                                                        0),
              2)                            as revenue_after_expenses_egp,

    -- ✅ Driver Info
        nvl(a.driver_share_type, 'NONE')    as driver_share_type,
        nvl(a.driver_share_value, 0)        as driver_share_value,
        case a.assignment_type
            when 'INSOURCE'  then
                nvl(cd.driver_name, 'غير معروف')
            when 'OUTSOURCE' then
                nvl(s.supplier_name, 'غير معروف')
            else
                'غير معروف'
        end                                 as driver_name,

    -- ✅ Driver Share from Base Price
        case a.driver_share_type
            when 'PERCENT' then
                round((a.driver_share_value / 100) * greatest((p.price * nvl(p.exchange_rate, 1)) - nvl((
                    select
                        sum(e.amount)
                    from
                        limo_trip_expenses e
                    where
                        e.trip_id = t.trip_id
                ),
                                                                                                        0),
                                                              0),
                      2)
            when 'FIXED'   then
                round(a.driver_share_value, 2)
            else
                0
        end                                 as driver_share_from_trip_egp,

    -- ✅ Driver Share from Services (50%)
        round(nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                  0) * 0.5,
              2)                            as driver_share_from_services_egp,

    -- ✅ Total Invoice (Base + Services)
        round((p.price * nvl(p.exchange_rate, 1)) + nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                                                        0),
              2)                            as total_invoice_egp,
        round(p.price +(nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                            0) / nullif(p.exchange_rate, 0)),
              2)                            as total_invoice_currency,

    -- ✅ Total Driver Payout (Trip Share + Services Share)
        round(
            case a.driver_share_type
                when 'PERCENT' then
                    (a.driver_share_value / 100) * greatest((p.price * nvl(p.exchange_rate, 1)) - nvl((
                        select
                            sum(e.amount)
                        from
                            limo_trip_expenses e
                        where
                            e.trip_id = t.trip_id
                    ),
                                                                                                      0),
                                                            0)
                when 'FIXED'   then
                    a.driver_share_value
                else
                    0
            end
            +(nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                  0) * 0.5),
            2)                            as total_driver_payout_egp,

    -- ✅ Office Net (what remains after driver payout)
        round((p.price * nvl(p.exchange_rate, 1)) + nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                                                        0) - nvl((
            select
                sum(e.amount)
            from
                limo_trip_expenses e
            where
                e.trip_id = t.trip_id
        ),
                                                                 0) -(
            case a.driver_share_type
                when 'PERCENT' then
                    (a.driver_share_value / 100) * greatest((p.price * nvl(p.exchange_rate, 1)) - nvl((
                        select
                            sum(e.amount)
                        from
                            limo_trip_expenses e
                        where
                            e.trip_id = t.trip_id
                    ),
                                                                                                      0),
                                                            0)
                when 'FIXED'   then
                    a.driver_share_value
                else
                    0
            end
            + nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                  0) * 0.5),
              2)                            as office_net_egp,
        round(((p.price * nvl(p.exchange_rate, 1)) + nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                                                         0) - nvl((
            select
                sum(e.amount)
            from
                limo_trip_expenses e
            where
                e.trip_id = t.trip_id
        ),
                                                                  0) -(
            case a.driver_share_type
                when 'PERCENT' then
                    (a.driver_share_value / 100) * greatest((p.price * nvl(p.exchange_rate, 1)) - nvl((
                        select
                            sum(e.amount)
                        from
                            limo_trip_expenses e
                        where
                            e.trip_id = t.trip_id
                    ),
                                                                                                      0),
                                                            0)
                when 'FIXED'   then
                    a.driver_share_value
                else
                    0
            end
            + nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                  0) * 0.5)) / nullif(p.exchange_rate, 0),
              2)                            as office_net_currency,

    -- ✅ Payments
        (
            select
                nvl(
                    sum(c.amount_collected),
                    0
                )
            from
                limo_trip_collections c
            where
                    c.trip_id = t.trip_id
                and c.currency = 'EGP'
        )                                   as paid_amount_egp,
        (
            select
                nvl(
                    sum(c.amount_collected),
                    0
                )
            from
                limo_trip_collections c
            where
                    c.trip_id = t.trip_id
                and c.currency = p.currency
        )                                   as paid_amount_orig_curr,

    -- ✅ Outstanding Calculations
        round(((p.price * nvl(p.exchange_rate, 1)) + nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                                                         0)) - nvl((
            select
                sum(c.amount_collected)
            from
                limo_trip_collections c
            where
                    c.trip_id = t.trip_id
                and c.currency = 'EGP'
        ),
                                                                   0),
              2)                            as outstanding_amount_egp,
        round((p.price +(nvl((
            select
                sum(s.amount_egp)
            from
                limo_add_services s
            where
                s.trip_id = t.trip_id
        ),
                             0) / nullif(p.exchange_rate, 0))) - nvl((
            select
                sum(c.amount_collected)
            from
                limo_trip_collections c
            where
                    c.trip_id = t.trip_id
                and c.currency = p.currency
        ),
                                                                     0),
              2)                            as outstanding_amount_orig_curr
    from
             limo_trips_tracker_v2 t
        join limo_products            p on t.product_id = p.product_id
        left join limo_product_assignments a on t.assignment_id = a.assignment_id
        left join company_drivers          cd on a.assignment_type = 'INSOURCE'
                                        and cd.driver_id = a.driver_id
        left join suppliers                s on a.assignment_type = 'OUTSOURCE'
                                 and to_char(s.supplier_id) = a.driver_id;

