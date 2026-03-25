create or replace editionable trigger trg_collections_recalc_v2 for
    insert or update or delete on limo_trip_collections
compound trigger
    type t_trip_set is
        table of boolean index by varchar2(50);
    g_trip_ids t_trip_set;

    procedure mark_trip (
        p_trip_id varchar2
    ) is
    begin
        if p_trip_id is not null then
            g_trip_ids(p_trip_id) := true; -- set semantics
        end if;
    end;

    before each row is begin
        if inserting
        or updating then
            mark_trip(:new.trip_id);
        elsif deleting then
            mark_trip(:old.trip_id);
        end if;
    end before each row;
    after statement is
        k varchar2(50);
    begin
        k := g_trip_ids.first;
        while k is not null loop
            begin
                recalc_trip_accounting_v2(k);
            exception
                when others then
                    dbms_output.put_line('Recalc error for trip '
                                         || k
                                         || ': ' || sqlerrm);
            end;

            k := g_trip_ids.next(k);
        end loop;

    end after statement;
end trg_collections_recalc_v2;
/

alter trigger trg_collections_recalc_v2 enable;


-- sqlcl_snapshot {"hash":"005d1d3f65188b418dbcf7241e1c24b2e93dab99","type":"TRIGGER","name":"TRG_COLLECTIONS_RECALC_V2","schemaName":"WKSP_ELWAGHA50","sxml":""}