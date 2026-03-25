-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463890371 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\ref_constraints\default_currency.currencies.sql
-- sqlcl_snapshot src/database/dev_schema/ref_constraints/default_currency.currencies.sql:null:89c951a339fc5735b3cfe48d113cc6b5af568c14:create

alter table default_currency
    add
        foreign key ( currency_code )
            references currencies ( currency_code )
                on delete cascade
        enable;

