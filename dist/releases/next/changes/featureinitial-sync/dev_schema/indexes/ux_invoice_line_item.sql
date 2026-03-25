-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463847190 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_invoice_line_item.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_invoice_line_item.sql:null:692231ef4059a96e820623f3508199ce66fb735f:create

create unique index ux_invoice_line_item on
    invoice_lines (
        invoice_id,
        source_item_id
    );

