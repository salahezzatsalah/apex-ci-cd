-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463937484 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\clients.sql
-- sqlcl_snapshot src/database/dev_schema/tables/clients.sql:null:e20a27791a8f2ed961e351c7d728782394156450:create

create table clients (
    client_id          varchar2(32 byte),
    client_code        varchar2(50 byte),
    full_name          varchar2(255 byte),
    gender             varchar2(10 byte),
    nationality        varchar2(50 byte),
    country            varchar2(100 byte),
    city               varchar2(100 byte),
    language           varchar2(10 byte),
    status             varchar2(20 byte) default 'ACTIVE',
    source_channel     varchar2(100 byte),
    date_of_birth      date,
    notes              varchar2(1000 byte),
    created_at         timestamp(6) with time zone,
    created_by         varchar2(100 byte),
    updated_at         timestamp(6) with time zone,
    updated_by         varchar2(100 byte),
    last_activity_at   date,
    legacy_client_id   varchar2(36 byte),
    phone_country_code varchar2(5 byte),
    phone_country_name varchar2(100 byte),
    first_seen_at      timestamp(6),
    last_seen_at       timestamp(6),
    country_code       varchar2(10 byte),
    country_name       varchar2(100 byte),
    profile_image_url  varchar2(4000 byte),
    profile_photo_url  varchar2(4000 byte),
    email              varchar2(200 byte)
);

alter table clients add primary key ( client_id )
    using index enable;

