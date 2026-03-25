-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463927715 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\api_client_tokens.sql
-- sqlcl_snapshot src/database/dev_schema/tables/api_client_tokens.sql:null:28f0c33156dc56c6c55138476b1c7fb8a1a8509b:create

create table api_client_tokens (
    token_id   varchar2(36 byte) default rawtohex(sys_guid()),
    client_id  varchar2(100 byte),
    jti        varchar2(64 byte),
    expires_at timestamp(6) with time zone,
    revoked_at timestamp(6) with time zone,
    created_at timestamp(6) with time zone default systimestamp
);

alter table api_client_tokens add primary key ( token_id )
    using index enable;

