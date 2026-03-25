-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463928525 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\api_clients.sql
-- sqlcl_snapshot src/database/dev_schema/tables/api_clients.sql:null:43cd0c133cbd45ab00f1620fee49c8bb6331d542:create

create table api_clients (
    client_id          varchar2(100 byte),
    client_name        varchar2(200 byte),
    client_secret_hash varchar2(64 byte),
    active             char(1 byte) default 'Y',
    created_at         timestamp(6) with time zone default systimestamp,
    created_by         varchar2(100 byte),
    updated_at         timestamp(6) with time zone,
    updated_by         varchar2(100 byte)
);

alter table api_clients add primary key ( client_id )
    using index enable;

