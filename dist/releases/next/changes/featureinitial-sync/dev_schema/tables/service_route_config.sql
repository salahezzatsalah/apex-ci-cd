-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464030319 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\service_route_config.sql
-- sqlcl_snapshot src/database/dev_schema/tables/service_route_config.sql:null:a08bd2eed1b68f7aa4e60e9a52b99e05fdc940cc:create

create table service_route_config (
    ref_table            varchar2(100 byte),
    service_code         varchar2(50 byte),
    details_page_no      number,
    details_item_name    varchar2(50 byte),
    assignment_page_no   number,
    assignment_item_name varchar2(50 byte),
    is_active            varchar2(1 byte) default 'Y'
);

alter table service_route_config add primary key ( ref_table )
    using index enable;

