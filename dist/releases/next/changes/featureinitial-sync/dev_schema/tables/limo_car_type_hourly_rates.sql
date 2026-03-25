-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463983409 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_car_type_hourly_rates.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_car_type_hourly_rates.sql:null:45686cc215f4f4ca132fe0c7fe0d2a2b7d0ef880:create

create table limo_car_type_hourly_rates (
    rate_id        varchar2(32 byte),
    car_type_id    varchar2(255 byte),
    hours          number(2, 0),
    base_price     number(10, 2),
    currency       varchar2(10 byte) default 'EGP',
    is_active      char(1 byte) default 'Y',
    effective_from timestamp(6) default systimestamp,
    effective_to   timestamp(6),
    notes          varchar2(500 byte),
    created        timestamp(6) default systimestamp,
    created_by     varchar2(100 byte),
    updated        timestamp(6),
    updated_by     varchar2(100 byte)
);

alter table limo_car_type_hourly_rates add primary key ( rate_id )
    using index enable;

