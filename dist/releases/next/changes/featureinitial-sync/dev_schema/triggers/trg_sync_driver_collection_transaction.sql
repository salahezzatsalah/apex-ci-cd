-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464117804 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_sync_driver_collection_transaction.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_sync_driver_collection_transaction.sql:null:27830053ecb6b55e36700967c871f5411422dbfc:create

create or replace editionable trigger trg_sync_driver_collection_transaction after
    insert or update on limo_trip_collections
    for each row
declare begin
    if (
        :new.collected_by_type = 'DRIVER'
        and :new.collection_method = 'CASH'
    ) then
        sync_driver_collection_transaction(
            p_collection_id   => :new.collection_id,
            p_trip_id         => :new.trip_id,
            p_assignment_id   => :new.assignment_id,
            p_collection_date => :new.collection_datetime,
            p_amount          => :new.amount_collected,
            p_currency        => :new.currency,
            p_collected_by_id => :new.collected_by_id,
            p_collector_name  => :new.collector_name,
            p_receipt_note    => :new.receipt_note,
            p_created_by      => nvl(:new.created_by,
                                user)
        );

    end if;
end;
/

alter trigger trg_sync_driver_collection_transaction enable;

