-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463941798 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\currencies.sql
-- sqlcl_snapshot src/database/dev_schema/tables/currencies.sql:null:43658352ee2941b32b53689e289507d0229ee558:create

create table currencies (
    currency_code    varchar2(10 byte),
    currency_name_ar varchar2(100 byte),
    currency_name_en varchar2(100 byte),
    symbol           varchar2(10 byte),
    status           varchar2(20 byte) default 'ACTIVE',
    created_by       varchar2(100 byte),
    created          timestamp(6) with time zone,
    flag_blob        blob,
    flag_mime_type   varchar2(255 byte),
    flag_filename    varchar2(255 byte),
    flag_last_update timestamp(6) default systimestamp
);

alter table currencies add primary key ( currency_code )
    using index enable;

