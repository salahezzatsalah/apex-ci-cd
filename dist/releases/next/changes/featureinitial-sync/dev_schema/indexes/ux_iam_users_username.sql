-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463846746 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_iam_users_username.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_iam_users_username.sql:null:0b6312464007e3347adb09394fdd7e3181d09707:create

create unique index ux_iam_users_username on
    iam_users ( upper(username) );

