-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463826771 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_oish_item_date.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_oish_item_date.sql:null:c5e65accb2a9b73750a26dbcf22af4d718d37e29:create

create index ix_oish_item_date on
    order_item_status_history (
        order_item_id,
        changed_at
    desc );

