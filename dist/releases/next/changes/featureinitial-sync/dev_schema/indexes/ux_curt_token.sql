-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463843170 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_curt_token.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_curt_token.sql:null:34390c006777aa07ba85eb584eb13c34deadac14:create

create unique index ux_curt_token on
    customer_user_refresh_tokens (
        refresh_token
    );

