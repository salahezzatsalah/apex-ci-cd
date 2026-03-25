-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463889952 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\ref_constraints\currency_rates.currencies.sql
-- sqlcl_snapshot src/database/dev_schema/ref_constraints/currency_rates.currencies.sql:null:f6bed39d54013b1a4440aa8e20f706f498d16e4c:create

alter table currency_rates
    add
        foreign key ( currency_code )
            references currencies ( currency_code )
        enable;

