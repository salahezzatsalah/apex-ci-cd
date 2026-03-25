-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463926170 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\airports.sql
-- sqlcl_snapshot src/database/dev_schema/tables/airports.sql:null:7699ce92126d941a0a84575e148070d9ee6d347f:create

create table airports (
    airport_id   varchar2(10 byte),
    airport_code varchar2(5 byte),
    airport_name varchar2(200 byte),
    city_name    varchar2(200 byte),
    country_name varchar2(200 byte),
    is_active    char(1 byte) default 'Y',
    created_at   date default sysdate,
    created      date,
    created_by   varchar2(100 byte),
    updated      date,
    updated_by   varchar2(100 byte)
);

alter table airports add primary key ( airport_id )
    using index enable;

