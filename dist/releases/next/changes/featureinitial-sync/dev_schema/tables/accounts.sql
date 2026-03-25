-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463924984 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\accounts.sql
-- sqlcl_snapshot src/database/dev_schema/tables/accounts.sql:null:35fe0d4b832d8cc711e163c7e43244398a4b3425:create

create table accounts (
    account_id    number generated always as identity not null enable,
    account_code  varchar2(50 byte),
    account_name  varchar2(200 byte),
    account_type  varchar2(50 byte),
    currency_code varchar2(10 byte),
    status        varchar2(20 byte) default 'ACTIVE',
    created       timestamp(6) default systimestamp,
    created_by    varchar2(100 byte),
    updated       timestamp(6),
    updated_by    varchar2(100 byte),
    owner_type    varchar2(50 byte),
    owner_id      varchar2(50 byte)
);

alter table accounts add primary key ( account_id )
    using index enable;

alter table accounts add unique ( account_code )
    using index enable;

