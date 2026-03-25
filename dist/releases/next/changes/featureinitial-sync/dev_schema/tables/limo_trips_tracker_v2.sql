-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464008234 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_trips_tracker_v2.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_trips_tracker_v2.sql:null:466765960af2ca25795961b6b85ebab2ea9e4164:create

create table limo_trips_tracker_v2 (
    trip_id        varchar2(30 byte),
    product_id     varchar2(30 byte),
    assignment_id  varchar2(30 byte),
    driver_id      varchar2(30 byte),
    status         varchar2(20 byte),
    start_datetime timestamp(6) with time zone,
    end_datetime   timestamp(6) with time zone,
    used_car_id    varchar2(50 byte),
    used_car_type  varchar2(100 byte),
    executed_date  date,
    created        timestamp(6) with time zone default systimestamp,
    created_by     varchar2(100 byte),
    updated        timestamp(6) with time zone,
    updated_by     varchar2(100 byte),
    sattle_status  varchar2(20 byte) default 'PENDING'
);

alter table limo_trips_tracker_v2 add primary key ( trip_id )
    using index enable;

