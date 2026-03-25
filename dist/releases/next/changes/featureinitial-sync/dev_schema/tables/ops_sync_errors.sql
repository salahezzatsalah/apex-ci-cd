-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464012661 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\ops_sync_errors.sql
-- sqlcl_snapshot src/database/dev_schema/tables/ops_sync_errors.sql:null:cf8b9e4e52ac95c2ff34bad1cc1213d2dd5d1f2a:create

create table ops_sync_errors (
    error_id      number generated always as identity not null enable,
    order_item_id varchar2(50 byte),
    error_source  varchar2(50 byte),
    error_message varchar2(4000 byte),
    error_stack   clob,
    created_at    date default sysdate,
    created_by    varchar2(100 byte),
    status        varchar2(20 byte) default 'NEW'
);

create unique index pk_ops_sync_errors on
    ops_sync_errors (
        error_id
    );

alter table ops_sync_errors
    add constraint pk_ops_sync_errors primary key ( error_id )
        using index pk_ops_sync_errors enable;

