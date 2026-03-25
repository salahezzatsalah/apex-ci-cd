-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463832776 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_order_items_fulfillment_status.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_order_items_fulfillment_status.sql:null:7d02a8b06da0af1c6a55ce5c8c266700ee2d8c3b:create

create index ix_order_items_fulfillment_status on
    order_items (
        fulfillment_status
    );

