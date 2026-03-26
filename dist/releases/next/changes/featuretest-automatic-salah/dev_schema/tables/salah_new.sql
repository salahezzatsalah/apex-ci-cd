-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774513275357 stripComments:false  logicalFilePath:featuretest-automatic-salah\dev_schema\tables\salah_new.sql
-- sqlcl_snapshot src/database/dev_schema/tables/salah_new.sql:null:a45627a6eea2c4508198039923d509dbdcb8ff82:create

create table salah_new (
    id  number,
    msg varchar2(100 byte)
);

alter table salah_new add primary key ( id )
    using index enable;

