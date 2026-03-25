-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463985663 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_car_type_prices.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_car_type_prices.sql:null:3cf9449228f0196ff97421cffc5e719129e4da9b:create

create table limo_car_type_prices (
    price_id       number generated always as identity not null enable,
    car_type_id    varchar2(240 byte),
    price_per_trip number(10, 2),
    currency       varchar2(10 byte) default 'EGP',
    exchange_rate  number(10, 4) default 1,
    amount_in_egp  number generated always as ( price_per_trip * exchange_rate ) virtual,
    is_special     varchar2(1 byte) default 'N',
    created        timestamp(6) with time zone default systimestamp,
    created_by     varchar2(100 byte),
    updated        timestamp(6) with time zone,
    updated_by     varchar2(100 byte),
    notes          varchar2(500 byte),
    start_date     timestamp(6) with time zone,
    end_date       timestamp(6) with time zone
);

alter table limo_car_type_prices add primary key ( price_id )
    using index enable;

