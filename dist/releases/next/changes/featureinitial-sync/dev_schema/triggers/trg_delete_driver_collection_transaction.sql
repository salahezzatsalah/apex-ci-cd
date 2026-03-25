-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464088523 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_delete_driver_collection_transaction.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_delete_driver_collection_transaction.sql:null:214b0307abeefc74028af73e044f69d262d5a009:create

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

