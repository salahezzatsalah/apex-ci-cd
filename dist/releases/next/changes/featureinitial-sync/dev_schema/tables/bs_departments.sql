-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463932453 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\bs_departments.sql
-- sqlcl_snapshot src/database/dev_schema/tables/bs_departments.sql:null:44336fc65b0a7bb5deb8788f4fe13d966be60add:create

create table bs_departments (
    id              number,
    department_name varchar2(255 char),
    description     varchar2(1000 char),
    status          varchar2(1 char) default 'A',
    created_by      varchar2(100 char) default user,
    updated_by      varchar2(100 char) default user,
    created         timestamp(6) with time zone,
    updated         timestamp(6) with time zone
);

alter table bs_departments add primary key ( id )
    using index enable;

