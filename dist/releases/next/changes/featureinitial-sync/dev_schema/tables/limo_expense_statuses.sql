-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463991267 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_expense_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_expense_statuses.sql:null:5fe1a7ba1bfd35bdec3de6011136b8d5762a8e17:create

create table limo_expense_statuses (
    status_code varchar2(30 byte),
    status_name varchar2(100 byte)
);

alter table limo_expense_statuses add primary key ( status_code )
    using index enable;

