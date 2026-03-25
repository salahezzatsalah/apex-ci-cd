-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463808885 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\iam_identities_idx_tenant_phone.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/iam_identities_idx_tenant_phone.sql:null:43c8c57d96db4c55c5ce2f296dba3d8d882967d4:create

create index iam_identities_idx_tenant_phone on
    iam_identities (
        tenant_id,
        phone_number
    );

