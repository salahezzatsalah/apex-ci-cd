-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464083951 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_collections_recalc_v2.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_collections_recalc_v2.sql:null:e163d38cd984cdc53b46ddd191bda27e6553f68c:create

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

