-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463950164 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\driver_share_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/driver_share_types.sql:null:5786c98304839f01fe97c2a80d261e2089460068:create

create table driver_share_types (
    share_type_code varchar2(10 byte),
    label_en        varchar2(50 byte),
    label_ar        varchar2(50 byte),
    is_active       char(1 byte) default 'Y',
    display_order   number(3, 0),
    created_by      varchar2(30 byte),
    updated_by      varchar2(30 byte),
    created         timestamp(6) with time zone,
    updated         timestamp(6) with time zone
);

alter table driver_share_types add primary key ( share_type_code )
    using index enable;

