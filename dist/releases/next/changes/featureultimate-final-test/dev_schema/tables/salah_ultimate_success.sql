-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774517270511 stripComments:false  logicalFilePath:featureultimate-final-test\dev_schema\tables\salah_ultimate_success.sql
-- sqlcl_snapshot src/database/dev_schema/tables/salah_ultimate_success.sql:null:1c73f3f64ace5513261d5aab8cbcff662272f1e1:create

create table salah_ultimate_success (
    id  number,
    msg varchar2(100 byte) default 'CI/CD IS WORKING PERFECTLY'
);

alter table salah_ultimate_success add primary key ( id )
    using index enable;

