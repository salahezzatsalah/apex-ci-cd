-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464047705 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\ycloud_sync_state.sql
-- sqlcl_snapshot src/database/dev_schema/tables/ycloud_sync_state.sql:null:15fd6636f1d632bdcdc6da8f408065c07b9d85cf:create

create table ycloud_sync_state (
    sync_name   varchar2(50 byte),
    last_offset number default 0,
    last_run_at timestamp(6),
    status      varchar2(20 byte),
    last_error  varchar2(1000 byte)
);

alter table ycloud_sync_state add primary key ( sync_name )
    using index enable;

