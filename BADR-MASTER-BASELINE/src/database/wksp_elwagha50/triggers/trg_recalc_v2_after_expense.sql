create or replace editionable trigger trg_recalc_v2_after_expense for
    insert or update or delete on limo_trip_expenses
compound trigger
    type t_trip_ids is
        table of varchar2(30);
    g_trip_ids t_trip_ids := t_trip_ids();

  -- Row-level: collect trip IDs
    before each row is begin
        if inserting
        or updating then
            g_trip_ids.extend;
            g_trip_ids(g_trip_ids.last) := :new.trip_id;
        elsif deleting then
            g_trip_ids.extend;
            g_trip_ids(g_trip_ids.last) := :old.trip_id;
        end if;
    end before each row;

  -- After statement: recalc once per trip
    after statement is begin
        for i in 1..g_trip_ids.count loop
            begin
                recalc_trip_accounting_v2(g_trip_ids(i));
            exception
                when others then
                    dbms_output.put_line('Recalc error for trip '
                                         || g_trip_ids(i)
                                         || ': ' || sqlerrm);
            end;
        end loop;
    end after statement;
end trg_recalc_v2_after_expense;
/

alter trigger trg_recalc_v2_after_expense enable;


-- sqlcl_snapshot {"hash":"3acce7ffcc3b11cd46f8a8f28bfaa8d06e80e164","type":"TRIGGER","name":"TRG_RECALC_V2_AFTER_EXPENSE","schemaName":"WKSP_ELWAGHA50","sxml":""}