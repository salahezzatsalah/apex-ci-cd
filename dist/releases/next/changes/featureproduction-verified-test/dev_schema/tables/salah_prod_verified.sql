-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774516414296 stripComments:false  logicalFilePath:featureproduction-verified-test\dev_schema\tables\salah_prod_verified.sql
-- sqlcl_snapshot src/database/dev_schema/tables/salah_prod_verified.sql:null:fdb4ed9a2a256415bab11128abc024d75ef6d671:create

create table salah_prod_verified (
    id         number,
    status     varchar2(50 byte) default 'ACTIVE',
    created_at timestamp(6) default current_timestamp
);

alter table salah_prod_verified add primary key ( id )
    using index enable;

