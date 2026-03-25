-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463943547 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\customer_user_refresh_tokens.sql
-- sqlcl_snapshot src/database/dev_schema/tables/customer_user_refresh_tokens.sql:null:af4e3923096521bd7fd1cd4956d4c48e00b573c3:create

create table customer_user_refresh_tokens (
    token_id      varchar2(36 byte) default rawtohex(sys_guid()),
    user_id       varchar2(36 byte),
    refresh_token varchar2(4000 byte),
    expires_at    timestamp(6) with time zone,
    revoked_at    timestamp(6) with time zone,
    created_at    timestamp(6) with time zone default systimestamp,
    created_by    varchar2(100 byte)
);

alter table customer_user_refresh_tokens add primary key ( token_id )
    using index enable;

