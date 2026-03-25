-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464007410 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_trip_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_trip_types.sql:null:ea2a0d3fae77c37a24b0671bbc56cce40ca74851:create

create table limo_trip_types (
    trip_type_code varchar2(20 byte),
    name_ar        varchar2(100 byte),
    name_en        varchar2(100 byte),
    description    varchar2(400 byte),
    active_yn      varchar2(1 byte) default 'Y',
    created        timestamp(6) with time zone default systimestamp,
    created_by     varchar2(100 byte),
    updated        timestamp(6) with time zone,
    updated_by     varchar2(100 byte)
);

alter table limo_trip_types add primary key ( trip_type_code )
    using index enable;

