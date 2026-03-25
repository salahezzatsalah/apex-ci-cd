-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463989270 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_driver_settlements.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_driver_settlements.sql:null:29d2d8c97841cb455c4a90377653f669713ba297:create

create table limo_driver_settlements (
    id              varchar2(30 byte),
    driver_id       varchar2(50 byte),
    assignment_id   varchar2(30 byte),
    product_id      varchar2(30 byte),
    settlement_date date default sysdate,
    settlement_type varchar2(30 byte),
    currency        varchar2(10 byte),
    amount          number(12, 2),
    exchange_rate   number(12, 6) default 1,
    amount_egp      number generated always as ( amount * exchange_rate ) virtual,
    settled_by      varchar2(50 byte),
    created         date default sysdate,
    created_by      varchar2(50 byte),
    notes           varchar2(4000 byte)
);

alter table limo_driver_settlements add primary key ( id )
    using index enable;

