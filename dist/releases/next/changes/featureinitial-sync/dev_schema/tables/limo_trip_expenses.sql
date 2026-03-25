-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464004016 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_trip_expenses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_trip_expenses.sql:null:4cce618fd47b40c6b4058281eb022fd997c08913:create

create table limo_trip_expenses (
    expense_id        varchar2(50 byte),
    trip_id           varchar2(50 byte),
    assignment_id     varchar2(50 byte),
    amount            number(10, 2),
    currency          varchar2(10 byte) default 'EGP',
    exchange_rate     number(10, 4) default 1,
    details           varchar2(500 byte),
    status            varchar2(30 byte),
    expense_type      varchar2(50 byte),
    from_account      varchar2(100 byte),
    approved_by       varchar2(50 byte),
    created_by        varchar2(50 byte),
    updated_by        varchar2(50 byte),
    approval_datetime timestamp(6) with time zone,
    created           timestamp(6) with time zone,
    updated           timestamp(6) with time zone,
    expense_date      timestamp(6) with time zone
);

alter table limo_trip_expenses add primary key ( expense_id )
    using index enable;

