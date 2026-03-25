-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464000887 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_search_runtime.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_search_runtime.sql:null:3a016928ed90fef3c1fba76fc702d01e979736d3:create

create table limo_search_runtime (
    runtime_id   number generated always as identity not null enable,
    session_id   varchar2(100 byte),
    user_id      number,
    service_type varchar2(30 byte),
    car_type_id  varchar2(255 byte),
    distance_km  number,
    duration_min number,
    hours        number,
    base_price   number,
    final_price  number,
    currency     varchar2(10 byte),
    route_json   clob,
    status       varchar2(20 byte) default 'NEW',
    created_at   timestamp(6) default systimestamp,
    valid_until  timestamp(6),
    price_model  varchar2(20 byte)
);

