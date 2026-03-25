-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463993110 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_product_assignments.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_product_assignments.sql:null:42b68f917aca0bae5a0b473bd6701e24b8fc7aa2:create

create table limo_product_assignments (
    assignment_id                varchar2(30 byte),
    product_id                   varchar2(30 byte),
    reservation_id               varchar2(30 byte),
    driver_id                    varchar2(30 byte),
    assignment_type              varchar2(20 byte),
    created_by                   varchar2(30 byte),
    updated_by                   varchar2(30 byte),
    driver_status                varchar2(20 byte) default 'CURRENT',
    driver_share_type            varchar2(10 byte),
    driver_share_value           number(10, 2),
    currency                     varchar2(10 byte) default 'EGP',
    exchange_rate                number(10, 4) default 1,
    created                      timestamp(6) with time zone,
    updated                      timestamp(6) with time zone,
    direct_collect_by_driver_yn  varchar2(1 byte) default 'N',
    assigned_registered_car_id   varchar2(20 byte),
    notes                        varchar2(300 byte),
    trips_made                   number(10, 0),
    total_trips_amount           number(12, 2),
    total_trips_amount_egp       number(12, 2),
    driver_total_payout_egp      number(12, 2),
    office_net_egp               number(12, 2),
    total_expenses_egp           number(12, 2),
    total_added_services_egp     number(12, 2),
    total_collected_egp          number(12, 2),
    collections_by_currency_json clob,
    accounting_updated_at        timestamp(6) with time zone
);

alter table limo_product_assignments add primary key ( assignment_id )
    using index enable;

