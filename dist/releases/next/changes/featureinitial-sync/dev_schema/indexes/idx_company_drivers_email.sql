-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463811018 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_company_drivers_email.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_company_drivers_email.sql:null:291a0f396bbfd3c492a6f13d99eccaf95e59c47c:create

create index idx_company_drivers_email on
    company_drivers (
        email
    );

