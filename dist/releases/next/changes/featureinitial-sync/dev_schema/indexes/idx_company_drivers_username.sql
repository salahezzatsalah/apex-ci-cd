-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463812629 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_company_drivers_username.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_company_drivers_username.sql:null:684872095dbafb5687c5b78474998b58a0bafb6e:create

create unique index idx_company_drivers_username on
    company_drivers (
        username
    );

