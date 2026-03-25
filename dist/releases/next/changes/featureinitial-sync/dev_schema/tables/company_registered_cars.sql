-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463940413 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\company_registered_cars.sql
-- sqlcl_snapshot src/database/dev_schema/tables/company_registered_cars.sql:null:3e3d45f7f0bce7490724a56c216da79952e03ada:create

create table company_registered_cars (
    id                     varchar2(20 byte),
    car_name               varchar2(100 byte),
    car_type_id            varchar2(50 byte),
    model_name             varchar2(100 byte),
    year                   number(4, 0),
    license_plate          varchar2(20 byte),
    color                  varchar2(30 byte),
    chassis_number         varchar2(40 byte),
    created_by             varchar2(50 byte),
    created                timestamp(6) default sysdate,
    status                 varchar2(20 byte) default 'ACTIVE',
    notes                  varchar2(2000 byte),
    profile_photo_blob     blob,
    profile_photo_filename varchar2(512 byte),
    profile_photo_mimetype varchar2(255 byte),
    profile_photo_lastupd  date,
    updated                timestamp(6),
    updated_by             varchar2(50 byte),
    photo_url              varchar2(2000 byte)
);

alter table company_registered_cars add primary key ( id )
    using index enable;

alter table company_registered_cars add unique ( license_plate )
    using index enable;

