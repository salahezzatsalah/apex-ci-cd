-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463846332 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_iam_tenants_code.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_iam_tenants_code.sql:null:ef638751385b628f31d29a7c64ae218b6d125f0b:create

create unique index ux_iam_tenants_code on
    iam_tenants ( upper(tenant_code) );

