-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463924133 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\account_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/account_types.sql:null:113e3885e50caa27edeb4a95a54f8a920a7fb55a:create

create table account_types (
    account_type_code varchar2(50 byte),
    name_en           varchar2(200 byte),
    name_ar           varchar2(200 byte),
    category          varchar2(50 byte),
    status            varchar2(20 byte) default 'ACTIVE',
    created           timestamp(6) default systimestamp,
    created_by        varchar2(100 byte),
    updated           timestamp(6),
    updated_by        varchar2(50 byte)
);

alter table account_types add primary key ( account_type_code )
    using index enable;

