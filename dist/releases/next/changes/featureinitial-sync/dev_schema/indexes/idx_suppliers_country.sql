-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463816945 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_suppliers_country.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_suppliers_country.sql:null:ce25301abb36378466277c0e3cfeea251e7e8a00:create

create index idx_suppliers_country on
    suppliers (
        country_id
    );

