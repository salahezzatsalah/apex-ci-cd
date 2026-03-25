-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463956334 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fast_track_service_catalog.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fast_track_service_catalog.sql:null:28a209041c689801fdb873bc1df751dda260711a:create

create table fast_track_service_catalog (
    service_id              varchar2(20 byte),
    service_name            varchar2(200 byte),
    service_desc            varchar2(1000 byte),
    active                  varchar2(1 byte) default 'Y',
    default_price           number(10, 2),
    default_currency        varchar2(10 byte) default 'EGP',
    is_per_person           varchar2(1 byte) default 'Y',
    is_vat_included         varchar2(1 byte) default 'N',
    created                 timestamp(6) default current_timestamp,
    created_by              varchar2(30 byte),
    updated                 timestamp(6),
    updated_by              varchar2(30 byte),
    service_pic_blob        blob,
    service_pic_filename    varchar2(512 byte),
    service_pic_mimetype    varchar2(255 byte),
    service_pic_lastupd     date,
    service_pic_url         varchar2(4000 byte),
    service_pic_object_name varchar2(1000 byte)
);

alter table fast_track_service_catalog add primary key ( service_id )
    using index enable;

