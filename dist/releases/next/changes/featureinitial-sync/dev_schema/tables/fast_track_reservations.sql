-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463955472 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fast_track_reservations.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fast_track_reservations.sql:null:cb3b834d23f02687232f683fbd61b9b42fbbb280:create

create table fast_track_reservations (
    reservation_id      varchar2(30 byte),
    client_id           varchar2(30 byte),
    reservation_type    varchar2(50 byte),
    reservation_date    date,
    res_time            varchar2(5 byte),
    ticket_no           varchar2(30 byte),
    passengers_no       number(4, 0),
    currency            varchar2(10 byte),
    price_per_person    number(10, 2) default 0,
    total_amount        number(12, 2) generated always as ( price_per_person * passengers_no ) virtual,
    status              varchar2(30 byte) default 'PENDING',
    signage_details     varchar2(300 byte),
    reservation_details varchar2(300 byte),
    notes               varchar2(1000 byte),
    request_source      varchar2(30 byte),
    fulfilled_by        varchar2(30 byte),
    paid_to             varchar2(30 byte),
    commission_type     varchar2(20 byte),
    commission_value    number(10, 2),
    commission_amount   number(12, 2),
    settlement_id       varchar2(30 byte),
    created             timestamp(6) default current_timestamp,
    created_by          varchar2(30 byte),
    updated             timestamp(6),
    updated_by          varchar2(30 byte),
    service_id          varchar2(20 byte),
    exchange_rate       number,
    related_reservation varchar2(50 byte),
    vendor_id           varchar2(50 byte)
);

alter table fast_track_reservations add primary key ( reservation_id )
    using index enable;

