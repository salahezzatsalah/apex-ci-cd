create or replace package body limo_driver_settlement_pkg as

    procedure create_driver_settlement (
        p_driver_id     in varchar2,
        p_settlement_id out varchar2
    ) is

      /* ===============================
         Audit
         =============================== */
        l_created_by               varchar2(50);

      /* ===============================
         Totals
         =============================== */
        l_trip_count               number := 0;
        l_working_days             number := 0;
        l_start_date               date;
        l_end_date                 date;
        l_total_expenses_egp       number := 0;
        l_total_driver_payout_egp  number := 0;
        l_total_collected_egp      number := 0;
        l_company_due_egp          number := 0;
        l_company_pay_driver_egp   number := 0;
        l_egp_available            number := 0;
        l_foreign_currency_summary clob;
    begin
      /* =====================================================
         0. Guard clause
         ===================================================== */
        if p_driver_id is null then
            raise_application_error(-20000, 'Driver ID is required for settlement.');
        end if;

      /* =====================================================
         1. Resolve CREATED_BY (APEX first)
         ===================================================== */
        begin
            l_created_by := apex_util.get_session_state('APP_USER_ID');
        exception
            when others then
                l_created_by := null;
        end;

        l_created_by := nvl(l_created_by, user);

      /* =====================================================
         2. Generate Settlement ID
         ===================================================== */
        p_settlement_id := 'SET-'
                           || p_driver_id
                           || '-'
                           || to_char(systimestamp, 'YYYYMMDDHH24MISSFF3');

      /* =====================================================
         3. Aggregate unsettled trips
         ===================================================== */
        select
            count(*),
            count(distinct executed_date),
            min(executed_date),
            max(executed_date),
            sum(nvl(trip_expenses_egp, 0)),
            sum(nvl(total_driver_payout_egp, 0))
        into
            l_trip_count,
            l_working_days,
            l_start_date,
            l_end_date,
            l_total_expenses_egp,
            l_total_driver_payout_egp
        from
            limo_trips_tracker_v2 t
        where
                t.sattle_status <> 'SETTLED'
            and t.executed_date is not null
            and t.driver_id = p_driver_id;

        if l_trip_count = 0 then
            raise_application_error(-20001, 'No unsettled trips found for this driver.');
        end if;

      /* =====================================================
         4. Collected EGP
         ===================================================== */
        select
            nvl(
                sum(amount_egp),
                0
            )
        into l_total_collected_egp
        from
            limo_trip_collections c
        where
            c.trip_id in (
                select
                    trip_id
                from
                    limo_trips_tracker_v2
                where
                        sattle_status <> 'SETTLED'
                    and driver_id = p_driver_id
            );

      /* =====================================================
         5. Settlement math
         ===================================================== */
        l_egp_available := l_total_collected_egp - l_total_driver_payout_egp - l_total_expenses_egp;
        if l_egp_available >= 0 then
            l_company_due_egp := l_egp_available;
        else
            l_company_pay_driver_egp := abs(l_egp_available);
        end if;

      /* =====================================================
         6. Foreign currencies snapshot
         ===================================================== */
        select
            listagg(to_char(
                sum(amount_collected),
                'FM999G999G999D00'
            )
                    || ' '
                    || currency,
                    ' | ') within group(
            order by
                currency
            )
        into l_foreign_currency_summary
        from
            limo_trip_collections
        where
                currency <> 'EGP'
            and trip_id in (
                select
                    trip_id
                from
                    limo_trips_tracker_v2
                where
                        sattle_status <> 'SETTLED'
                    and driver_id = p_driver_id
            )
        group by
            currency;

      /* =====================================================
         7. Insert settlement master
         ===================================================== */
        insert into limo_trip_settlements (
            settlement_id,
            driver_id,
            trip_count,
            working_days,
            period_start,
            period_end,
            total_expenses_egp,
            total_driver_payout_egp,
            total_collected_egp,
            company_due_egp,
            company_pay_driver_egp,
            foreign_currencies_summary,
            created_by
        ) values ( p_settlement_id,
                   p_driver_id,
                   l_trip_count,
                   l_working_days,
                   l_start_date,
                   l_end_date,
                   l_total_expenses_egp,
                   l_total_driver_payout_egp,
                   l_total_collected_egp,
                   l_company_due_egp,
                   l_company_pay_driver_egp,
                   l_foreign_currency_summary,
                   l_created_by );

      /* =====================================================
         8. Attach trips + mark settled
         ===================================================== */
        for r in (
            select
                trip_id
            from
                limo_trips_tracker_v2
            where
                    sattle_status <> 'SETTLED'
                and driver_id = p_driver_id
        ) loop
            insert into limo_trip_settlement_items (
                settlement_id,
                trip_id
            ) values ( p_settlement_id,
                       r.trip_id );

            update limo_trips_tracker_v2
            set
                sattle_status = 'SETTLED'
            where
                trip_id = r.trip_id;

        end loop;

        commit;
    end create_driver_settlement;

end limo_driver_settlement_pkg;
/


-- sqlcl_snapshot {"hash":"4f49a08146d29d02f1c4118cce1ceaf5c3596025","type":"PACKAGE_BODY","name":"LIMO_DRIVER_SETTLEMENT_PKG","schemaName":"DEV_SCHEMA","sxml":""}