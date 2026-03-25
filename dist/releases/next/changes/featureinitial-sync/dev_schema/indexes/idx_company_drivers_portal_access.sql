-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463812236 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_company_drivers_portal_access.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_company_drivers_portal_access.sql:null:630113ab2d8c66a8488beb3059288daef8847205:create

create index idx_company_drivers_portal_access on
    company_drivers (
        has_portal_access
    );

