-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464040868 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\transactions.sql
-- sqlcl_snapshot src/database/dev_schema/tables/transactions.sql:null:be344300eafb4a1483a6c8c76ddecf391a51a15c:create

create table transactions (
    transaction_id   number,
    transaction_date timestamp(6),
    description      varchar2(500 byte),
    reference_number varchar2(100 byte),
    status           varchar2(20 byte) default 'POSTED',
    created          timestamp(6) default systimestamp,
    created_by       varchar2(100 byte),
    updated          timestamp(6),
    updated_by       varchar2(100 byte)
);

alter table transactions add primary key ( transaction_id ) disable;

