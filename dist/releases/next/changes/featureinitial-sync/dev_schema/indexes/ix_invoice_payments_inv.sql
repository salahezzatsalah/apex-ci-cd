-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463823991 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_invoice_payments_inv.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_invoice_payments_inv.sql:null:3ba5bfe99ab3628d9c4518d7d5b90aee71d2c88b:create

create index ix_invoice_payments_inv on
    invoice_payments (
        invoice_id
    );

