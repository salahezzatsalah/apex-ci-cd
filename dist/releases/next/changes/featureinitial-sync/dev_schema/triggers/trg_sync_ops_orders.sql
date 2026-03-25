-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464118583 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_sync_ops_orders.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_sync_ops_orders.sql:null:eca45b66e257d40b77befa6c135e4b2ce239e4d8:create

create or replace editionable trigger trg_sync_ops_orders after
    insert or update of fulfillment_status, assigned_to_name, amount_egp, service_start_ts on order_items
    for each row
begin
    ops_sync_pkg.sync_item(:new.order_item_id);
end;
/

alter trigger trg_sync_ops_orders enable;

