-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463984813 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_car_type_km_prices.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_car_type_km_prices.sql:null:14f52b3777c4da4eded2df4fec285023cf0c8adb:create

create table limo_car_type_km_prices (
    price_id       varchar2(32 byte),
    car_type_id    varchar2(255 byte),
    price_per_km   number(12, 2),
    currency       varchar2(10 byte) default 'USD',
    is_active      char(1 byte) default 'Y',
    effective_from timestamp(6) with time zone default systimestamp,
    effective_to   timestamp(6) with time zone,
    notes          varchar2(1000 byte),
    created        timestamp(6) with time zone,
    created_by     varchar2(200 byte),
    updated        timestamp(6) with time zone,
    updated_by     varchar2(200 byte)
);

alter table limo_car_type_km_prices add primary key ( price_id )
    using index enable;

