-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463847683 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_invoice_main_res.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_invoice_main_res.sql:null:d09ffb3534e30b4777a232d868c61683c2a1f8f6:create

create unique index ux_invoice_main_res on
    invoices (
        main_res_id
    );

