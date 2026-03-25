create or replace editionable trigger trg_sync_ops_orders after
    insert or update of fulfillment_status, assigned_to_name, amount_egp, service_start_ts on order_items
    for each row
begin
    ops_sync_pkg.sync_item(:new.order_item_id);
end;
/

alter trigger trg_sync_ops_orders enable;


-- sqlcl_snapshot {"hash":"db3e2392c828fd5e8150a600ceec12dc62bfa97a","type":"TRIGGER","name":"TRG_SYNC_OPS_ORDERS","schemaName":"DEV_SCHEMA","sxml":""}