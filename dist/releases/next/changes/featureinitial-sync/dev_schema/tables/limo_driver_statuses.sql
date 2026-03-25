-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463990126 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_driver_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_driver_statuses.sql:null:cc88721e0135ec0aaa96036a1ce917253a6f4726:create

create table limo_driver_statuses (
    driver_status_code varchar2(20 byte),
    status_label_en    varchar2(100 byte),
    status_label_ar    varchar2(100 byte),
    display_order      number(3, 0),
    is_active          char(1 byte) default 'Y',
    created_by         varchar2(30 byte),
    updated_by         varchar2(30 byte),
    created            timestamp(6) with time zone,
    updated            timestamp(6) with time zone
);

alter table limo_driver_statuses add primary key ( driver_status_code )
    using index enable;

