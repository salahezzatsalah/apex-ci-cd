-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464001561 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_trip_accounting.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_trip_accounting.sql:null:332e241cd8fee95e031f393c0f971d3c1a775560:create

create table limo_trip_accounting (
    accounting_id           varchar2(30 byte),
    trip_id                 varchar2(30 byte),
    sub_res_id              varchar2(30 byte),
    trip_price              number(12, 2),
    currency                varchar2(10 byte),
    exchange_rate           number(12, 6),
    base_price_egp          number(12, 2),
    added_services_egp      number(12, 2),
    added_services_currency number(12, 2),
    expenses_egp            number(12, 2),
    revenue_after_exp_egp   number(12, 2),
    driver_share_type       varchar2(10 byte),
    driver_share_value      number(12, 2),
    driver_share_from_trip  number(12, 2),
    driver_share_from_serv  number(12, 2),
    driver_payout_egp       number(12, 2),
    total_invoice_egp       number(12, 2),
    total_invoice_currency  number(12, 2),
    office_net_egp          number(12, 2),
    office_net_currency     number(12, 2),
    paid_egp                number(12, 2),
    paid_orig_curr          number(12, 2),
    outstanding_egp         number(12, 2),
    outstanding_orig_curr   number(12, 2),
    last_calc_at            timestamp(6) with time zone,
    created                 timestamp(6) with time zone default systimestamp,
    created_by              varchar2(100 byte),
    updated                 timestamp(6) with time zone,
    updated_by              varchar2(100 byte)
);

create unique index uk_lta_trip on
    limo_trip_accounting (
        trip_id
    );

alter table limo_trip_accounting
    add constraint uk_lta_trip unique ( trip_id )
        using index uk_lta_trip enable;

alter table limo_trip_accounting add primary key ( accounting_id )
    using index enable;

