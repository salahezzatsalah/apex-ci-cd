-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463833857 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_promo_usage_invoice.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_promo_usage_invoice.sql:null:c0c3f193ff163f358361b034c5c366019c84ab5f:create

create index ix_promo_usage_invoice on
    promo_usage (
        invoice_id
    );

