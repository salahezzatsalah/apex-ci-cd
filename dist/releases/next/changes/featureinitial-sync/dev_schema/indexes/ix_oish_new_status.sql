-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463827241 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_oish_new_status.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_oish_new_status.sql:null:93a028a377e25fbb4953d1f322889a29cabe1047:create

create index ix_oish_new_status on
    order_item_status_history (
        new_status
    );

