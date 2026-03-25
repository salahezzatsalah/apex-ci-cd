-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464036771 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\supplier_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/supplier_statuses.sql:null:5be81fb8f60cfce3b5da589c54a5124b01c9f4ba:create

create table supplier_statuses (
    status_code varchar2(10 byte),
    status_name varchar2(100 byte)
);

alter table supplier_statuses add primary key ( status_code )
    using index enable;

