-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463945212 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\customer_user_tokens.sql
-- sqlcl_snapshot src/database/dev_schema/tables/customer_user_tokens.sql:null:60896e4050c9a54551cffc8a4cace8247f6d5d12:create

create table customer_user_tokens (
    token_id     varchar2(36 byte) default rawtohex(sys_guid()),
    user_id      varchar2(36 byte),
    access_token varchar2(4000 byte),
    expires_at   timestamp(6) with time zone,
    created_at   timestamp(6) with time zone default systimestamp,
    created_by   varchar2(100 byte)
);

alter table customer_user_tokens add primary key ( token_id )
    using index enable;

