-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463822486 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_iam_usg_user.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_iam_usg_user.sql:null:e4afd59c0d1b3c1acaa73b5253a07e8196e755b8:create

create index ix_iam_usg_user on
    iam_user_security_groups (
        user_id
    );

