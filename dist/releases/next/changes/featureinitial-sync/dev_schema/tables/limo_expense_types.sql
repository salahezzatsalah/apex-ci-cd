-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463992272 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_expense_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_expense_types.sql:null:5176f2fd8e43cd384ba5d79f8eb3095d25d5e887:create

create table limo_expense_types (
    expense_type_code varchar2(50 byte),
    expense_type_name varchar2(100 byte),
    sortno            number
);

alter table limo_expense_types add primary key ( expense_type_code )
    using index enable;

