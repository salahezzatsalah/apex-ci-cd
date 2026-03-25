-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463837158 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_api_client_tokens_jti.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_api_client_tokens_jti.sql:null:f783dad910d5bda4848f37e465029bf092e9e626:create

create unique index ux_api_client_tokens_jti on
    api_client_tokens (
        jti
    );

