-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463946057 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\customer_users.sql
-- sqlcl_snapshot src/database/dev_schema/tables/customer_users.sql:null:1ecd403314da6aa5ee5546d0bd32f86af5afe282:create

create table customer_users (
    user_id       varchar2(32 byte) default rawtohex(sys_guid()),
    client_id     varchar2(36 byte),
    username      varchar2(150 byte),
    user_type     varchar2(20 byte) default 'PHONE',
    password_hash varchar2(500 byte),
    status        varchar2(20 byte) default 'PENDING',
    verified      char(1 byte) default 'N',
    last_login_at timestamp(6) with time zone,
    created_at    timestamp(6) with time zone default systimestamp,
    created_by    varchar2(100 byte),
    updated_at    timestamp(6) with time zone,
    updated_by    varchar2(100 byte)
);

alter table customer_users add primary key ( user_id )
    using index enable;

