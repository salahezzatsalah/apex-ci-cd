-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464104678 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_lpa_from_collections.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_lpa_from_collections.sql:null:b5ea0abaec9e24addefd1939e736cea58e9fd816:create

create or replace editionable trigger trg_lpa_from_collections for
    insert or update or delete on limo_trip_collections
compound trigger
    type t_set is
        table of pls_integer index by varchar2(50);
    g_assign_ids t_set;

    procedure mark (
        p_id varchar2
    ) is
    begin
        if p_id is not null then
            g_assign_ids(p_id) := 1;
        end if;
    end;

    before each row is begin
        if inserting
        or updating then
            mark(:new.assignment_id);
        end if;
        if deleting then
            mark(:old.assignment_id);
        end if;
    end before each row;
    after statement is
        k varchar2(50);
    begin
        k := g_assign_ids.first;
        while k is not null loop
            begin
                recalc_assignment_accounting(k);
            exception
                when others then
                    dbms_output.put_line('LPA recalc (COLL) failed for '
                                         || k
                                         || ': ' || sqlerrm);
            end;

            k := g_assign_ids.next(k);
        end loop;

    end after statement;
end trg_lpa_from_collections;
/

alter trigger trg_lpa_from_collections enable;

