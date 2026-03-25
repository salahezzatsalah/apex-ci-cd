create or replace editionable trigger trg_delete_driver_collection_transaction before
    delete on limo_trip_collections
    for each row
declare
    v_transaction_id transactions.transaction_id%type;
begin
    -- Only for driver cash collections
    if (
        :old.collected_by_type = 'DRIVER'
        and :old.collection_method = 'CASH'
    ) then
        for rec in (
            select
                transaction_id
            from
                transactions
            where
                reference_number = :old.collection_id
        ) loop
            delete from transaction_entries
            where
                transaction_id = rec.transaction_id;

            delete from transactions
            where
                transaction_id = rec.transaction_id;

        end loop;

    end if;
end;
/

alter trigger trg_delete_driver_collection_transaction enable;


-- sqlcl_snapshot {"hash":"f4e555c056491b4ec57edfe8901f838e1bc5a6c1","type":"TRIGGER","name":"TRG_DELETE_DRIVER_COLLECTION_TRANSACTION","schemaName":"DEV_SCHEMA","sxml":""}