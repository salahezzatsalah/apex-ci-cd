-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463822059 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ix_iam_usg_group.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ix_iam_usg_group.sql:null:7c0cf7aab9e46ce29a69e6bf32e547af853df55e:create

create index ix_iam_usg_group on
    iam_user_security_groups (
        group_id
    );

