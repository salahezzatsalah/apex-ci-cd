-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463968097 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_user_security_groups.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_user_security_groups.sql:null:11cd341cc5f48926212004615fd77c0837be9315:create

create table iam_user_security_groups (
    user_id       varchar2(32 byte),
    group_id      varchar2(32 byte),
    role_in_group varchar2(20 byte) default 'USER',
    is_active_yn  varchar2(1 byte) default 'Y',
    assigned_at   timestamp(6) with time zone default systimestamp,
    assigned_by   varchar2(32 byte)
);

create unique index pk_iam_user_group on
    iam_user_security_groups (
        user_id,
        group_id
    );

alter table iam_user_security_groups
    add constraint pk_iam_user_group
        primary key ( user_id,
                      group_id )
            using index pk_iam_user_group enable;

