-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463969451 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_users.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_users.sql:null:a42a0ea4e71f8fd899f36ff866fce3c81bab5441:create

create table iam_users (
    user_id           varchar2(32 byte) default lower(rawtohex(sys_guid())),
    tenant_id         varchar2(32 byte),
    username          varchar2(100 byte),
    password_hash     varchar2(64 byte),
    email             varchar2(255 byte),
    phone_number      varchar2(50 byte),
    global_role       varchar2(20 byte) default 'USER',
    status            varchar2(20 byte) default 'ACTIVE',
    account_locked_yn varchar2(1 byte) default 'N',
    legacy_user_id    varchar2(300 byte),
    created           timestamp(6) with time zone default systimestamp,
    updated           timestamp(6) with time zone,
    identity_id       varchar2(32 byte)
);

create unique index pk_iam_users on
    iam_users (
        user_id
    );

alter table iam_users
    add constraint pk_iam_users primary key ( user_id )
        using index pk_iam_users enable;

