-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463848995 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_orderitem_uniq.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_orderitem_uniq.sql:null:c5218182037a4c41da14ef3de128f72b63995ff6:create

create unique index ux_orderitem_uniq on
    order_items (
        item_type,
        ref_id
    );

