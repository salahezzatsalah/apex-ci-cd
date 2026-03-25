-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463977685 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_additional_service_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_additional_service_types.sql:null:a948fdf9fa185b58d2b322e220471d2326c3951d:create

create table limo_additional_service_types (
    service_type_code varchar2(50 byte),
    service_type_name varchar2(100 byte),
    unit_type         varchar2(20 byte) default 'UNIT',
    display_order     number,
    is_active         varchar2(1 byte) default 'Y'
);

alter table limo_additional_service_types add primary key ( service_type_code )
    using index enable;

