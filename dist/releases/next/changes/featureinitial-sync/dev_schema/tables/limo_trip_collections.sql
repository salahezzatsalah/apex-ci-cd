-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464003211 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_trip_collections.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_trip_collections.sql:null:1a24c90d10350edb370cf181d99868feb22629ef:create

create table limo_trip_collections (
    collection_id          varchar2(50 byte),
    trip_id                varchar2(50 byte),
    product_id             varchar2(50 byte),
    amount_collected       number(10, 2),
    currency               varchar2(10 byte) default 'EGP',
    exchange_rate_used     number(10, 4),
    collected_by_type      varchar2(10 byte),
    collected_by_id        varchar2(100 byte),
    collector_name         varchar2(255 byte),
    collection_datetime    timestamp(6) default systimestamp,
    collection_method      varchar2(50 byte),
    receipt_note           varchar2(4000 byte),
    created                timestamp(6) default systimestamp,
    created_by             varchar2(100 byte),
    receipt_photo_blob     blob,
    receipt_photo_mimetype varchar2(255 byte),
    receipt_photo_filename varchar2(400 byte),
    receipt_photo_uploaded timestamp(6),
    amount_egp             number generated always as ( amount_collected * nvl(exchange_rate_used, 1) ) virtual,
    assignment_id          varchar2(100 byte)
);

alter table limo_trip_collections add primary key ( collection_id )
    using index enable;

