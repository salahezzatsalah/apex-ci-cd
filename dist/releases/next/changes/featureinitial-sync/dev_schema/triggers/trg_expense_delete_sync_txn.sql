-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464091754 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_expense_delete_sync_txn.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_expense_delete_sync_txn.sql:null:af9cc7f9e1043cd54cfe75f67e7a1702dcf78499:create

create or replace editionable trigger trg_expense_delete_sync_txn after
    delete on limo_trip_expenses
    for each row
begin
    -- Just delete the transaction for this reference number
    for rec in (
        select
            transaction_id
        from
            transactions
        where
            reference_number = :old.expense_id
    ) loop
        delete from transaction_entries
        where
            transaction_id = rec.transaction_id;

        delete from transactions
        where
            transaction_id = rec.transaction_id;

    end loop;
end;
/

alter trigger trg_expense_delete_sync_txn enable;

