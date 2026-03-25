-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463965410 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_security_groups.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_security_groups.sql:null:c50f54b868f62b105d3deef29379000617e7bfd7:create

create table iam_security_groups (
    group_id     varchar2(32 byte) default lower(rawtohex(sys_guid())),
    group_code   varchar2(80 byte),
    group_name   varchar2(150 byte),
    description  varchar2(500 byte),
    is_active_yn varchar2(1 byte) default 'Y',
    created      timestamp(6) with time zone default systimestamp
);

create unique index pk_iam_security_groups on
    iam_security_groups (
        group_id
    );

alter table iam_security_groups
    add constraint pk_iam_security_groups primary key ( group_id )
        using index pk_iam_security_groups enable;

