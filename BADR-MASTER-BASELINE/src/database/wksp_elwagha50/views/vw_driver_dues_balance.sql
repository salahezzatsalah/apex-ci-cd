create or replace force editionable view vw_driver_dues_balance (
    assignment_id,
    assignment_end_date,
    product_id,
    reservation_id,
    assignment_type,
    driver_id,
    driver_name,
    assignment_type_ar,
    driver_share_type,
    driver_share_value,
    currency,
    driver_status,
    created_at,
    collection_note,
    driver_avatar,
    share_display,
    share_type_ar,
    share_percent_value,
    trips_made,
    driver_total_payout_egp,
    office_net_egp,
    total_expenses_egp,
    total_added_services_egp,
    total_collected_egp,
    collections_by_currency_json,
    driver_phone,
    driver_type_ar,
    dues_by_currency_json,
    remaining_dues_by_currency_json,
    company_due_from_driver_egp,
    driver_due_from_company_egp,
    driver_due_to_company_egp,
    settlements_by_currency_json,
    settlements_history_json,
    record_collect_yn,
    record_settle_yn
) as
    select
        assignment_id,
        assignment_end_date,
        product_id,
        reservation_id,
        assignment_type,
        driver_id,
        driver_name,
        assignment_type_ar,
        driver_share_type,
        driver_share_value,
        currency,
        driver_status,
        created_at,
        collection_note,
        driver_avatar,
        share_display,
        share_type_ar,
        share_percent_value,
        trips_made,
        driver_total_payout_egp,
        office_net_egp,
        total_expenses_egp,
        total_added_services_egp,
        total_collected_egp,
        collections_by_currency_json,
        driver_phone,
        driver_type_ar,
        dues_by_currency_json,
        remaining_dues_by_currency_json,
        company_due_from_driver_egp,
        driver_due_from_company_egp,
        driver_due_to_company_egp,
        settlements_by_currency_json,
        settlements_history_json,
        record_collect_yn,
        record_settle_yn
    from
        (
            select
                v.assignment_id,
                v.assignment_end_date,
                v.product_id,
                v.reservation_id,
                v.assignment_type,
                v.driver_id,
                v.driver_name,
                v.assignment_type_ar,
                v.driver_share_type,
                v.driver_share_value,
                v.currency,
                v.driver_status,
                v.created_at,
                v.collection_note,
                v.driver_avatar,
                v.share_display,
                v.share_type_ar,
                v.share_percent_value,
                v.trips_made,
                v.driver_total_payout_egp,
                v.office_net_egp,
                v.total_expenses_egp,
                v.total_added_services_egp,
                v.total_collected_egp,
                v.collections_by_currency_json,

    -- Phone
                case v.assignment_type
                    when 'INSOURCE'  then
                        cd.phone
                    when 'OUTSOURCE' then
                        s.phone
                end  as driver_phone,

    -- Driver type label
                case v.assignment_type
                    when 'INSOURCE'  then
                        'كباتن'
                    when 'OUTSOURCE' then
                        'سائق خارجي'
                    else
                        'غير معروف'
                end  as driver_type_ar,

    -- DUES_BY_CURRENCY_JSON
                (
                    select
                        json_arrayagg(
                            json_object(
                                'currency' value d.currency,
                                        'amount' value to_char(d.amount, '999G999G990D00'),
                                        'amount_egp' value to_char(d.amount_egp, '999G999G990D00'),
                                        'exchange_rate' value to_char(d.exchange_rate, '999G999G990D00')
                            )
                        returning clob)
                    from
                        (
                            select
                                c.currency,
                                sum(c.amount_collected) as amount,
                                sum(c.amount_egp)       as amount_egp,
                                max(nvl(
                                    nullif(c.exchange_rate_used, 0),
                                    1
                                ))                      as exchange_rate
                            from
                                limo_trip_collections c
                            where
                                    c.collected_by_type = 'DRIVER'
                                and upper(c.collected_by_id) = upper(v.driver_id)
                                and ( upper(c.assignment_id) = upper(v.assignment_id)
                                      or upper(c.product_id) = upper(v.product_id) )
                                and upper(c.currency) != 'EGP'
                            group by
                                c.currency
                            union all
                            select
                                'EGP',
                                v.total_collected_egp - v.driver_total_payout_egp,
                                v.total_collected_egp - v.driver_total_payout_egp,
                                1
                            from
                                dual
                            where
                                v.total_collected_egp > v.driver_total_payout_egp
                        ) d
                )    as dues_by_currency_json,

    -- REMAINING_DUES_BY_CURRENCY_JSON
                (
                    select
                        json_arrayagg(
                            json_object(
                                'currency' value r.currency,
                                        'remaining_amount' value to_char(r.amount, '999G999G990D00'),
                                        'remaining_amount_egp' value to_char(r.amount_egp, '999G999G990D00')
                            )
                        returning clob)
                    from
                        (
                            select
                                x.currency,
                                sum(x.amount)     as amount,
                                sum(x.amount_egp) as amount_egp
                            from
                                (
          -- Collections by driver
                                    select
                                        c.currency,
                                        sum(c.amount_collected) as amount,
                                        sum(c.amount_egp)       as amount_egp
                                    from
                                        limo_trip_collections c
                                    where
                                            c.collected_by_type = 'DRIVER'
                                        and upper(c.collected_by_id) = upper(v.driver_id)
                                        and ( upper(c.assignment_id) = upper(v.assignment_id)
                                              or upper(c.product_id) = upper(v.product_id) )
                                    group by
                                        c.currency
                                    union all
          -- FROM_DRIVER settlements (subtract)
                                    select
                                        s.currency,
                                        - sum(s.amount),
                                        - sum(s.amount_egp)
                                    from
                                        limo_driver_settlements s
                                    where
                                            s.settlement_type = 'FROM_DRIVER'
                                        and upper(s.driver_id) = upper(v.driver_id)
                                        and upper(s.assignment_id) = upper(v.assignment_id)
                                        and upper(s.product_id) = upper(v.product_id)
                                    group by
                                        s.currency
                                    union all
          -- TO_DRIVER settlements (add)
                                    select
                                        s.currency,
                                        sum(s.amount),
                                        sum(s.amount_egp)
                                    from
                                        limo_driver_settlements s
                                    where
                                            s.settlement_type = 'TO_DRIVER'
                                        and upper(s.driver_id) = upper(v.driver_id)
                                        and upper(s.assignment_id) = upper(v.assignment_id)
                                        and upper(s.product_id) = upper(v.product_id)
                                    group by
                                        s.currency
                                    union all
          -- Deduct driver payout for EGP only
                                    select
                                        'EGP',
                                        - v.driver_total_payout_egp,
                                        - v.driver_total_payout_egp
                                    from
                                        dual
                                    union all
          -- Deduct assignment expenses
                                    select
                                        'EGP',
                                        - v.total_expenses_egp,
                                        - v.total_expenses_egp
                                    from
                                        dual
                                ) x
                            group by
                                x.currency
                            having
                                sum(x.amount) > 0
                        ) r
                )    as remaining_dues_by_currency_json,

    -- COMPANY_DUE_FROM_DRIVER_EGP
                ( (
                    select
                        round(
                            sum(c.amount_collected * nvl(
                                nullif(c.exchange_rate_used, 0),
                                1
                            )),
                            2
                        )
                    from
                             limo_trip_collections c
                        join limo_trips_tracker_v2 t on c.trip_id = t.trip_id
                    where
                            c.collected_by_type = 'DRIVER'
                        and upper(c.collected_by_id) = upper(v.driver_id)
                        and ( upper(t.assignment_id) = upper(v.assignment_id)
                              or upper(t.product_id) = upper(v.product_id) )
                        and upper(c.currency) != 'EGP'
                ) +
                  case
                      when v.total_collected_egp > v.driver_total_payout_egp then
                            v.total_collected_egp - v.driver_total_payout_egp
                      else
                          0
                  end
                  - nvl((
                    select
                        sum(s.total_egp)
                    from
                        vw_driver_settlement_totals s
                    where
                            s.settlement_type = 'FROM_DRIVER'
                        and upper(s.driver_id) = upper(v.driver_id)
                        and upper(s.assignment_id) = upper(v.assignment_id)
                        and upper(s.product_id) = upper(v.product_id)
                ),
                        0) ) as company_due_from_driver_egp,

    -- DRIVER_DUE_FROM_COMPANY_EGP
                case
                    when v.driver_total_payout_egp + v.total_expenses_egp > v.total_collected_egp then
                        v.driver_total_payout_egp + v.total_expenses_egp - v.total_collected_egp - nvl((
                            select
                                sum(s.total_egp)
                            from
                                vw_driver_settlement_totals s
                            where
                                    s.settlement_type = 'TO_DRIVER'
                                and upper(s.driver_id) = upper(v.driver_id)
                                and upper(s.assignment_id) = upper(v.assignment_id)
                                and upper(s.product_id) = upper(v.product_id)
                        ),
                                                                                                       0)
                    else
                        0
                end  as driver_due_from_company_egp,

    -- DRIVER_DUE_TO_COMPANY_EGP
                case
                    when v.total_collected_egp > v.driver_total_payout_egp then
                        v.total_collected_egp - v.driver_total_payout_egp
                    else
                        0
                end  as driver_due_to_company_egp,

    -- SETTLEMENTS_BY_CURRENCY_JSON
                (
                    select
                        json_arrayagg(
                            json_object(
                                'type' value s.settlement_type,
                                        'currency' value s.currency,
                                        'amount' value to_char(
                                    sum(s.amount),
                                    '999G999G990D00'
                                ),
                                        'amount_egp' value to_char(
                                    sum(s.amount_egp),
                                    '999G999G990D00'
                                )
                            )
                        returning clob)
                    from
                        limo_driver_settlements s
                    where
                            upper(s.driver_id) = upper(v.driver_id)
                        and upper(s.assignment_id) = upper(v.assignment_id)
                        and upper(s.product_id) = upper(v.product_id)
                    group by
                        s.settlement_type,
                        s.currency
                )    as settlements_by_currency_json,

    -- SETTLEMENTS_HISTORY_JSON
                (
                    select
                        json_arrayagg(
                            json_object(
                                'type' value s.settlement_type,
                                        'currency' value s.currency,
                                        'amount' value to_char(s.amount, '999G999G990D00'),
                                        'amount_egp' value to_char(s.amount_egp, '999G999G990D00'),
                                        'settled_by' value s.settled_by,
                                        'settled_by_name' value s.first_name
                                                                || ' '
                                                                || s.last_name,
                                        'settlement_date' value to_char(s.settlement_date, 'YYYY-MM-DD HH24:MI:SS'),
                                        'notes' value s.notes
                            )
                        returning clob)
                    from
                        (
                            select
                                s.*,
                                e.first_name,
                                e.last_name
                            from
                                limo_driver_settlements s
                                left join bs_employees            e on e.id = s.settled_by
                            where
                                    upper(s.driver_id) = upper(v.driver_id)
                                and upper(s.assignment_id) = upper(v.assignment_id)
                                and upper(s.product_id) = upper(v.product_id)
                            order by
                                s.settlement_date desc
                        ) s
                )    as settlements_history_json,

    -- RECORD_COLLECT_YN
                case
                    when exists (
                        select
                            1
                        from
                            (
                                select
                                    x.currency
                                from
                                    (
            -- Collections by driver
                                        select
                                            c.currency,
                                            sum(c.amount_collected) as amount,
                                            sum(c.amount_egp)       as amount_egp
                                        from
                                                 limo_trip_collections c
                                            join limo_trips_tracker_v2 t on c.trip_id = t.trip_id
                                        where
                                                c.collected_by_type = 'DRIVER'
                                            and upper(c.collected_by_id) = upper(v.driver_id)
                                            and upper(t.assignment_id) = upper(v.assignment_id)
                                            and upper(t.product_id) = upper(v.product_id)
                                        group by
                                            c.currency
                                        union all
            -- FROM_DRIVER settlements (negative)
                                        select
                                            s.currency,
                                            - sum(s.amount),
                                            - sum(s.amount_egp)
                                        from
                                            limo_driver_settlements s
                                        where
                                                s.settlement_type = 'FROM_DRIVER'
                                            and upper(s.driver_id) = upper(v.driver_id)
                                            and upper(s.assignment_id) = upper(v.assignment_id)
                                            and upper(s.product_id) = upper(v.product_id)
                                        group by
                                            s.currency
                                        union all
            -- TO_DRIVER settlements (positive)
                                        select
                                            s.currency,
                                            sum(s.amount),
                                            sum(s.amount_egp)
                                        from
                                            limo_driver_settlements s
                                        where
                                                s.settlement_type = 'TO_DRIVER'
                                            and upper(s.driver_id) = upper(v.driver_id)
                                            and upper(s.assignment_id) = upper(v.assignment_id)
                                            and upper(s.product_id) = upper(v.product_id)
                                        group by
                                            s.currency
                                        union all
            -- Driver entitled payout (only in EGP)
                                        select
                                            'EGP',
                                            - v.driver_total_payout_egp,
                                            - v.driver_total_payout_egp
                                        from
                                            dual
                                        union all
            -- Deducted expenses
                                        select
                                            'EGP',
                                            - v.total_expenses_egp,
                                            - v.total_expenses_egp
                                        from
                                            dual
                                    ) x
                                group by
                                    x.currency
                                having
                                    sum(x.amount) > 0
                            )
                    ) then
                        'Y'
                    else
                        'N'
                end  as record_collect_yn,

    -- RECORD_SETTLE_YN
                case
                    when (
                        case
                            when v.driver_total_payout_egp + v.total_expenses_egp > v.total_collected_egp then
                                v.driver_total_payout_egp + v.total_expenses_egp - v.total_collected_egp - nvl((
                                    select
                                        sum(s.total_egp)
                                    from
                                        vw_driver_settlement_totals s
                                    where
                                            s.settlement_type = 'TO_DRIVER'
                                        and upper(s.driver_id) = upper(v.driver_id)
                                        and upper(s.assignment_id) = upper(v.assignment_id)
                                        and upper(s.product_id) = upper(v.product_id)
                                ),
                                                                                                               0)
                            else
                                0
                        end
                    ) > 0 then
                        'Y'
                    else
                        'N'
                end  as record_settle_yn
            from
                vw_driver_assignment_accounting v
                left join company_drivers                 cd on v.assignment_type = 'INSOURCE'
                                                and upper(cd.driver_id) = upper(v.driver_id)
                left join suppliers                       s on v.assignment_type = 'OUTSOURCE'
                                         and upper(s.supplier_id) = upper(v.driver_id)
        ) main
    where
        main.record_collect_yn = 'Y'
        or main.record_settle_yn = 'Y'
        or ( main.record_collect_yn = 'N'
             and main.record_settle_yn = 'N'
             and main.assignment_end_date >= add_months(
            trunc(sysdate),
            -2
        ) );


-- sqlcl_snapshot {"hash":"e95a281b5479674706df2f28256b834677142016","type":"VIEW","name":"VW_DRIVER_DUES_BALANCE","schemaName":"WKSP_ELWAGHA50","sxml":""}