create or replace force editionable view vw_driver_accounting (
    driver_id,
    driver_name,
    assignment_type,
    profile_photo,
    contact_phone,
    contact_email,
    contact_address,
    status,
    join_date,
    notes,
    assignments_count,
    total_trips_made,
    driver_total_payout_egp,
    total_expenses_egp,
    total_office_net_egp,
    total_collected_egp,
    driver_type_ar,
    remaining_dues_by_currency_json,
    company_due_from_driver_egp,
    driver_due_from_company_egp,
    driver_due_to_company_egp,
    settlements_by_currency_json,
    settlements_history_json
) as
    with v_agg as (
        select
            driver_id,
            count(*) as assignments_count,
            nvl(
                sum(trips_made),
                0
            )        as total_trips_made,
            nvl(
                sum(driver_total_payout_egp),
                0
            )        as driver_total_payout_egp,
            nvl(
                sum(total_expenses_egp),
                0
            )        as total_expenses_egp,
            nvl(
                sum(office_net_egp),
                0
            )        as total_office_net_egp,
            nvl(
                sum(total_collected_egp),
                0
            )        as total_collected_egp
        from
            vw_driver_assignment_accounting
        group by
            driver_id
    )
    select
        u.driver_id,
        u.driver_name,
        u.assignment_type,
        u.profile_photo,
        u.contact_phone,
        u.contact_email,
        u.contact_address,
        u.status,
        u.join_date,
        u.notes,
        v.assignments_count,
        v.total_trips_made,
        v.driver_total_payout_egp,
        v.total_expenses_egp,
        v.total_office_net_egp,
        v.total_collected_egp,
  -- Arabic Label
        case
            when u.assignment_type = 'INSOURCE'  then
                'كباتن'
            when u.assignment_type = 'OUTSOURCE' then
                'سائق خارجي'
            else
                'غير معروف'
        end  as driver_type_ar,
  -- Dues by currency JSON
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
                                and upper(c.collected_by_id) = upper(u.driver_id)
                            group by
                                c.currency
                            union all
        -- FROM_DRIVER settlements
                            select
                                s.currency,
                                - sum(s.amount),
                                - sum(s.amount_egp)
                            from
                                limo_driver_settlements s
                            where
                                    s.settlement_type = 'FROM_DRIVER'
                                and upper(s.driver_id) = upper(u.driver_id)
                            group by
                                s.currency
                            union all
        -- TO_DRIVER settlements
                            select
                                s.currency,
                                sum(s.amount),
                                sum(s.amount_egp)
                            from
                                limo_driver_settlements s
                            where
                                    s.settlement_type = 'TO_DRIVER'
                                and upper(s.driver_id) = upper(u.driver_id)
                            group by
                                s.currency
                            union all
        -- Deduct payout in EGP
                            select
                                'EGP',
                                - v.driver_total_payout_egp,
                                - v.driver_total_payout_egp
                            from
                                dual
                            union all
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
                        sum(x.amount) <> 0
                ) r
        )    as remaining_dues_by_currency_json,
  -- COMPANY_DUE_FROM_DRIVER_EGP
        ( (
            select
                round(
                    sum(c.amount_collected * nvl(
                        nullif(c.exchange_rate_used, 1),
                        1
                    )),
                    2
                )
            from
                limo_trip_collections c
            where
                    c.collected_by_type = 'DRIVER'
                and upper(c.collected_by_id) = upper(u.driver_id)
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
                and upper(s.driver_id) = upper(u.driver_id)
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
                        and upper(s.driver_id) = upper(u.driver_id)
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
  -- Settlements by currency JSON
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
                upper(s.driver_id) = upper(u.driver_id)
            group by
                s.settlement_type,
                s.currency
        )    as settlements_by_currency_json,
  -- Settlements history JSON
        (
            select
                json_arrayagg(
                    json_object(
                        'type' value s.settlement_type,
                                'currency' value s.currency,
                                'amount' value to_char(s.amount, '999G999G990D00'),
                                'amount_egp' value to_char(s.amount_egp, '999G999G990D00'),
                                'settled_by' value s.settled_by,
                                'settled_by_name' value e.first_name
                                                        || ' '
                                                        || e.last_name,
                                'settlement_date' value to_char(s.settlement_date, 'YYYY-MM-DD HH24:MI:SS'),
                                'notes' value s.notes
                    )
                returning clob)
            from
                limo_driver_settlements s
                left join bs_employees            e on e.id = s.settled_by
            where
                upper(s.driver_id) = upper(u.driver_id)
        )    as settlements_history_json
    from
        unified_drivers_list u
        left join v_agg                v on v.driver_id = u.driver_id;


-- sqlcl_snapshot {"hash":"7a7eae3d66648adf72a4bd730196096ddae32d53","type":"VIEW","name":"VW_DRIVER_ACCOUNTING","schemaName":"DEV_SCHEMA","sxml":""}