create or replace editionable trigger trg_ltxp_assign_id before
    insert on limo_trip_expenses
    for each row
begin
    if :new.expense_id is null then
        :new.expense_id := 'TRIPEXP-' || seq_limo_trip_expense.nextval;
    end if;
end;
/

alter trigger trg_ltxp_assign_id enable;


-- sqlcl_snapshot {"hash":"72462a64e867d3a9b13548a885eb93a303776e3d","type":"TRIGGER","name":"TRG_LTXP_ASSIGN_ID","schemaName":"DEV_SCHEMA","sxml":""}