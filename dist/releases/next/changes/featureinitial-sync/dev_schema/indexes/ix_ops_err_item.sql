-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463831338 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_ops_err_item.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_ops_err_item.sql:null:ed84f5e9ddc71c483bc641735908b25db6843385:create

create index ix_ops_err_item on
    ops_sync_errors (
        order_item_id
    );

