-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463944356 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\customer_user_reset_tokens.sql
-- sqlcl_snapshot src/database/dev_schema/tables/customer_user_reset_tokens.sql:null:2ab57e37bbbf3e16e40aed5410facaee8476040e:create

create table customer_user_reset_tokens (
    token_id    varchar2(36 byte) default rawtohex(sys_guid()),
    user_id     varchar2(36 byte),
    reset_token varchar2(4000 byte),
    expires_at  timestamp(6) with time zone,
    used_at     timestamp(6) with time zone,
    created_at  timestamp(6) with time zone default systimestamp
);

alter table customer_user_reset_tokens add primary key ( token_id )
    using index enable;

