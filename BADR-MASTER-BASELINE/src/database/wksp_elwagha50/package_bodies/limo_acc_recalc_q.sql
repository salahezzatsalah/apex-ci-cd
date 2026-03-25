create or replace package body limo_acc_recalc_q as

    type t_set is
        table of varchar2(30) index by varchar2(30);
    g_trip_set t_set;

    procedure add_trip (
        p_trip_id in varchar2
    ) is
    begin
        if p_trip_id is not null then
            g_trip_set(p_trip_id) := p_trip_id;
        end if;
    end;

    procedure add_assignment (
        p_assignment_id in varchar2
    ) is
    begin
        if p_assignment_id is null then
            return;
        end if;

    -- collect all trips under this assignment
        for r in (
            select
                trip_id
            from
                limo_trips_tracker_v2
            where
                assignment_id = p_assignment_id
        ) loop
            add_trip(r.trip_id);
        end loop;

    end;

    procedure flush is
        k varchar2(30);
    begin
        k := g_trip_set.first;
        while k is not null loop
            recalc_trip_accounting_v2(k, 'Y');
            k := g_trip_set.next(k);
        end loop;

        g_trip_set.delete;
    end;

end limo_acc_recalc_q;
/


-- sqlcl_snapshot {"hash":"f1e251e4b4f32f1299a4a9895567437a45fa836c","type":"PACKAGE_BODY","name":"LIMO_ACC_RECALC_Q","schemaName":"WKSP_ELWAGHA50","sxml":""}