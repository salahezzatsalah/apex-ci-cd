create or replace editionable trigger trg_lpa_from_v2 for
    insert or update or delete on limo_trips_tracker_v2
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
                    dbms_output.put_line('LPA recalc (V2) failed for '
                                         || k
                                         || ': ' || sqlerrm);
            end;

            k := g_assign_ids.next(k);
        end loop;

    end after statement;
end trg_lpa_from_v2;
/

alter trigger trg_lpa_from_v2 enable;


-- sqlcl_snapshot {"hash":"a55894b06ce566f118676e38e3f1b9afb6ab1686","type":"TRIGGER","name":"TRG_LPA_FROM_V2","schemaName":"WKSP_ELWAGHA50","sxml":""}