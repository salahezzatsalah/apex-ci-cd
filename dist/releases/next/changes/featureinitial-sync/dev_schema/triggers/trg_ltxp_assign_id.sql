-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464107934 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_ltxp_assign_id.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_ltxp_assign_id.sql:null:20d499014242d8f0e08212f65a1b3d32e8e05977:create

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

