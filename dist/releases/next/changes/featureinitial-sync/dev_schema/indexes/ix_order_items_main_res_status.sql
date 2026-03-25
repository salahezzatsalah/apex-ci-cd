-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463833339 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_order_items_main_res_status.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_order_items_main_res_status.sql:null:3220dbcfb28dbf6cf407203a6e693d546135da68:create

create index ix_order_items_main_res_status on
    order_items (
        main_res_id,
        fulfillment_status
    );

