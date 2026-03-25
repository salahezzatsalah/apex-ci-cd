-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464040037 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\transaction_entries.sql
-- sqlcl_snapshot src/database/dev_schema/tables/transaction_entries.sql:null:2581a42dca3cc599f86e8bd6381da13817123813:create

create table transaction_entries (
    entry_id         number generated always as identity not null enable,
    transaction_id   number,
    account_id       number,
    debit_amount     number(18, 4),
    credit_amount    number(18, 4),
    currency_code    varchar2(10 byte),
    exchange_rate    number(18, 6),
    base_amount      number(18, 4),
    notes            varchar2(500 byte),
    created          timestamp(6) default systimestamp,
    created_by       varchar2(100 byte),
    updated          timestamp(6),
    updated_by       varchar2(100 byte),
    transaction_type varchar2(10 byte)
);

alter table transaction_entries add primary key ( entry_id )
    using index enable;

