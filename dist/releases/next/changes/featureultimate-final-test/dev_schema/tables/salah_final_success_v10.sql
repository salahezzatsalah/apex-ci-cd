-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774521902848 stripComments:false  logicalFilePath:featureultimate-final-test\dev_schema\tables\salah_final_success_v10.sql
-- sqlcl_snapshot src/database/dev_schema/tables/salah_final_success_v10.sql:null:f76f9686474a6d540775c17cb7f35718bb2a2cf9:create

create table salah_final_success_v10 (
    id         number,
    name       varchar2(100 byte) default 'I love automation!',
    status     varchar2(50 byte) default 'DEPLOYED',
    created_at timestamp(6) default current_timestamp
);

alter table salah_final_success_v10 add primary key ( id )
    using index enable;

