-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463995143 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_products.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_products.sql:null:479aacea5fd30f81226e4a746b75c86fa4a5d15f:create

create table limo_products (
    product_id                       varchar2(30 byte),
    reservation_id                   varchar2(30 byte),
    car_type_id                      varchar2(30 byte),
    trip_type                        varchar2(20 byte),
    trip_time                        varchar2(5 byte),
    from_location                    varchar2(400 byte),
    to_location                      varchar2(400 byte),
    price                            number(10, 2),
    currency                         varchar2(10 byte) default 'EGP',
    exchange_rate                    number(10, 4) default 1,
    status                           varchar2(30 byte),
    notes                            varchar2(1000 byte),
    created                          timestamp(6) with time zone default systimestamp,
    created_by                       varchar2(100 byte),
    updated                          timestamp(6) with time zone,
    updated_by                       varchar2(100 byte),
    classification_type              varchar2(50 byte),
    ticket_number                    varchar2(300 byte),
    signage_details                  varchar2(300 byte),
    trip_date_from                   date,
    trip_date_to                     date,
    nod                              number generated always as ( trunc(nvl(trip_date_to, trip_date_from)) - trunc(trip_date_from) + 1
    ) virtual,
    total_price                      number(22, 2) generated always as ( price * ( trunc(nvl(trip_date_to, trip_date_from)) - trunc(trip_date_from
    ) + 1 ) ) virtual,
    amount_egp                       number(22, 2) generated always as ( price * exchange_rate * ( trunc(nvl(trip_date_to, trip_date_from
    )) - trunc(trip_date_from) + 1 ) ) virtual,
    trips_count                      number(10, 0),
    total_invoice_egp                number(12, 2),
    total_invoice_orig_curr          number(12, 2),
    total_added_services_egp         number(12, 2),
    total_expenses_egp               number(12, 2),
    total_revenue_after_expenses_egp number(12, 2),
    total_paid_egp                   number(12, 2),
    total_paid_orig_curr             number(12, 2),
    total_outstanding_egp            number(12, 2),
    total_outstanding_orig_curr      number(12, 2),
    total_driver_payout_egp          number(12, 2),
    total_office_net_egp             number(12, 2),
    total_office_net_orig_curr       number(12, 2),
    accounting_updated_at            timestamp(6) with time zone,
    is_deleted                       char(1 byte) default 'N',
    deleted                          timestamp(6) with time zone,
    deleted_by                       varchar2(100 byte)
);

alter table limo_products add primary key ( product_id )
    using index enable;

