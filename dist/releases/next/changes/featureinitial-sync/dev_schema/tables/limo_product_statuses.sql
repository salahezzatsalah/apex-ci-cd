-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463994014 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_product_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_product_statuses.sql:null:a009fb5fb0df71f9748dcd6b769de6d0b53e3dec:create

create table limo_product_statuses (
    status_code     varchar2(30 byte),
    status_label_en varchar2(100 byte),
    status_label_ar varchar2(100 byte),
    display_order   number(3, 0) default 0,
    icon_class      varchar2(100 byte),
    color_class     varchar2(50 byte),
    active_yn       varchar2(1 byte) default 'Y',
    created_by      varchar2(100 byte),
    updated_by      varchar2(100 byte),
    created         timestamp(6) with time zone,
    updated         timestamp(6) with time zone
);

alter table limo_product_statuses add primary key ( status_code )
    using index enable;

