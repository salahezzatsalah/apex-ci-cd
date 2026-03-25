-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463823075 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_invoice_adj_invoice.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_invoice_adj_invoice.sql:null:129d60082f269f6670c96dc29546659c332da956:create

create index ix_invoice_adj_invoice on
    invoice_adjustments (
        invoice_id
    );

