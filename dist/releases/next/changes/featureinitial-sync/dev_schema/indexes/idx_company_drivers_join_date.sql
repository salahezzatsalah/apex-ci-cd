-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463811809 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_company_drivers_join_date.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_company_drivers_join_date.sql:null:f6bab4fa86017df1b318c574622863f182a4b465:create

create index idx_company_drivers_join_date on
    company_drivers (
        join_date
    );

