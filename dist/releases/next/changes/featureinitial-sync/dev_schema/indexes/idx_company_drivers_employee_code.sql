-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463811409 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_company_drivers_employee_code.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_company_drivers_employee_code.sql:null:108c8b3002faf6e77c1c45324dd9baa856d01f44:create

create index idx_company_drivers_employee_code on
    company_drivers (
        employee_code
    );

