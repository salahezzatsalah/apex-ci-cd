-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463810375 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_company_drivers_dept.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_company_drivers_dept.sql:null:0a7c3a1b144c20751822afdf45f8123475074d6f:create

create index idx_company_drivers_dept on
    company_drivers (
        department_id
    );

