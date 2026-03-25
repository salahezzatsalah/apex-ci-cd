-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464042799 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\user_device_tokens.sql
-- sqlcl_snapshot src/database/dev_schema/tables/user_device_tokens.sql:null:f7617c5527ace50cb1b5c6c6a0cffb6689490516:create

create table user_device_tokens (
    id           varchar2(32 byte),
    user_id      varchar2(32 byte),
    fcm_token    varchar2(1000 byte),
    platform     varchar2(20 byte),
    device_name  varchar2(255 byte),
    is_active    char(1 byte) default 'Y',
    last_seen_at timestamp(6) default current_timestamp,
    created_at   timestamp(6) default current_timestamp
);

alter table user_device_tokens add primary key ( id )
    using index enable;

