-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463957209 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fast_track_service_prices.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fast_track_service_prices.sql:null:997349cf41c159c87eabd795ea4c16595ecf60e8:create

create table fast_track_service_prices (
    service_price_id number generated always as identity not null enable,
    service_id       varchar2(20 byte),
    price            number(10, 2),
    currency_code    varchar2(10 byte),
    effective_date   date default sysdate,
    created_by       varchar2(100 byte),
    created          timestamp(6) default current_timestamp,
    updated_by       varchar2(100 byte),
    updated          timestamp(6)
);

alter table fast_track_service_prices add primary key ( service_price_id )
    using index enable;

