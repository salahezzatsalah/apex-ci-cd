-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463845869 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_iam_groups_code.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_iam_groups_code.sql:null:ce639c555681c3e9a7866d2bf6359a4ba18ba0e2:create

create unique index ux_iam_groups_code on
    iam_security_groups ( upper(group_code) );

