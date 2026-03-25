-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464000020 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_reservations.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_reservations.sql:null:dc79713abf12b22d43468087adb45d2c2baddec9:create

create table limo_reservations (
    reservation_id       varchar2(30 byte),
    client_id            varchar2(30 byte),
    status               varchar2(30 byte),
    currency             varchar2(10 byte) default 'EGP',
    exchange_rate        number(10, 4) default 1,
    sales_rep_id         varchar2(30 byte),
    ops_rep_id           varchar2(30 byte),
    notes                varchar2(4000 byte),
    tags                 varchar2(4000 byte),
    created              timestamp(6) with time zone default systimestamp,
    created_by           varchar2(100 byte),
    updated              timestamp(6) with time zone,
    updated_by           varchar2(100 byte),
    archived_yn          varchar2(1 char) default 'N',
    archived_by          varchar2(255 byte),
    reservation_url_name varchar2(255 byte),
    time_trip            varchar2(5 byte),
    ticket_number        varchar2(300 byte),
    signage_details      varchar2(300 byte),
    classification_type  varchar2(50 byte),
    from_date            date,
    to_date              date,
    archived_date        timestamp(6) with time zone
);

alter table limo_reservations add primary key ( reservation_id )
    using index enable;

