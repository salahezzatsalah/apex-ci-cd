-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463844519 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_cut_token.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_cut_token.sql:null:85c25430df59152ab2c11e54c349c0dd658a3f03:create

create unique index ux_cut_token on
    customer_user_tokens (
        access_token
    );

