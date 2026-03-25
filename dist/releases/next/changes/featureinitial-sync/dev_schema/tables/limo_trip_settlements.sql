-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464006499 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_trip_settlements.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_trip_settlements.sql:null:54ce3a56632dd80f093d03e2706bc1ea60406805:create

create table limo_trip_settlements (
    settlement_id              varchar2(50 byte),
    driver_id                  varchar2(50 byte),
    car_id                     varchar2(50 byte),
    trip_count                 number,
    working_days               number,
    period_start               date,
    period_end                 date,
    total_expenses_egp         number,
    total_driver_payout_egp    number,
    total_collected_egp        number,
    company_due_egp            number,
    company_pay_driver_egp     number,
    foreign_currencies_summary clob,
    created                    timestamp(6) default systimestamp,
    created_by                 varchar2(50 byte),
    trips_json                 json,
    currencies_json            json
);

alter table limo_trip_settlements add primary key ( settlement_id )
    using index enable;

