-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463980223 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_car_type_categories.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_car_type_categories.sql:null:4aa96f1242ac2a1b6ca34ea9229b6f5faf7a6a20:create

create table limo_car_type_categories (
    category_id      varchar2(30 byte),
    category_name_ar varchar2(100 byte),
    category_name_en varchar2(100 byte),
    description      varchar2(400 byte),
    active_yn        varchar2(1 byte) default 'Y',
    created          timestamp(6) with time zone default systimestamp,
    created_by       varchar2(100 byte),
    updated          timestamp(6) with time zone,
    updated_by       varchar2(100 byte)
);

alter table limo_car_type_categories add primary key ( category_id )
    using index enable;

