-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463821524 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_iam_users_tenant.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_iam_users_tenant.sql:null:423d165d643dac6c0ca438b4d9a75718e16c26e6:create

create index ix_iam_users_tenant on
    iam_users (
        tenant_id
    );

