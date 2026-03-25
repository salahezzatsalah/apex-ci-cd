-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464017385 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\payment_methods.sql
-- sqlcl_snapshot src/database/dev_schema/tables/payment_methods.sql:null:11c8fb8fb081059b876be4ce94b2b52711b7d7c9:create

create table payment_methods (
    method_code   varchar2(30 byte),
    method_name   varchar2(100 byte),
    description   varchar2(500 byte),
    active_yn     char(1 byte) default 'Y',
    display_order number(3, 0),
    icon          varchar2(100 byte)
);

alter table payment_methods add primary key ( method_code )
    using index enable;

