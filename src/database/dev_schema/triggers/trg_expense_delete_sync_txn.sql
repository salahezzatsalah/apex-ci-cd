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


-- sqlcl_snapshot {"hash":"2c1e19a26f0e071d2386ddd2e40389baa4e95f5f","type":"TRIGGER","name":"TRG_EXPENSE_DELETE_SYNC_TXN","schemaName":"DEV_SCHEMA","sxml":""}