-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463818597 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\idx_suppliers_username.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/idx_suppliers_username.sql:null:7c896b142f03b6dd255044a6534b96e2b3a84124:create

create unique index idx_suppliers_username on
    suppliers (
        username
    );

