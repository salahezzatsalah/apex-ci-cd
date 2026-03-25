-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464114591 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_services_recalc_v2.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_services_recalc_v2.sql:null:2318be7a9606f3b9ef13d3ef5966fe90b2af867d:create

create or replace editionable trigger trg_services_recalc_v2 for
    insert or update or delete on limo_add_services
compound trigger
    type t_trip_tab is
        table of varchar2(50);
    g_trip_tab t_trip_tab := t_trip_tab();

    procedure add_trip (
        p_trip_id varchar2
    ) is
    begin
        if p_trip_id is not null then
            g_trip_tab.extend;
            g_trip_tab(g_trip_tab.count) := p_trip_id;
        end if;
    end;

    function uniq (
        p t_trip_tab
    ) return t_trip_tab is

        l_set   t_trip_tab := t_trip_tab();
        l_seen  sys.odcivarchar2list := sys.odcivarchar2list();
        l_found boolean;
    begin
        if p.count = 0 then
            return l_set;
        end if;
        for i in 1..p.count loop
            l_found := false;
            for j in 1..l_seen.count loop
                if l_seen(j) = p(i) then
                    l_found := true;
                    exit;
                end if;
            end loop;

            if not l_found then
                l_seen.extend;
                l_seen(l_seen.count) := p(i);
                l_set.extend;
                l_set(l_set.count) := p(i);
            end if;

        end loop;

        return l_set;
    end;

    before each row is begin
        if inserting
        or updating then
            add_trip(:new.trip_id);
        elsif deleting then
            add_trip(:old.trip_id);
        end if;
    end before each row;
    after statement is
        l_trips t_trip_tab := uniq(g_trip_tab);
    begin
        for i in 1..l_trips.count loop
            begin
        -- Recalc trip totals in V2
                recalc_trip_accounting_v2(l_trips(i));

        -- Optional: if you want to sync driver payout only when trip is finished
        --IF (SELECT status FROM LIMO_TRIPS_TRACKER_V2 WHERE trip_id = l_trips(i)) = 'FINISHED' THEN
        --  SYNC_DRIVER_PAYOUT_FOR_TRIP(l_trips(i));
        --END IF;
            exception
                when others then
                    dbms_output.put_line('Recalc error for trip '
                                         || l_trips(i)
                                         || ': ' || sqlerrm);
            end;
        end loop;
    end after statement;
end trg_services_recalc_v2;
/

alter trigger trg_services_recalc_v2 enable;

