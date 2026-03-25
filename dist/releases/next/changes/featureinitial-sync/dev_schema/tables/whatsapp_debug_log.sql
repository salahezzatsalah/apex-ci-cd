-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464044408 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\whatsapp_debug_log.sql
-- sqlcl_snapshot src/database/dev_schema/tables/whatsapp_debug_log.sql:null:3392445f7a300c69e996abf44169af4a5d9ec2e6:create

create table whatsapp_debug_log (
    id           number generated always as identity not null enable,
    full_payload clob,
    received_at  date default sysdate
);

alter table whatsapp_debug_log add primary key ( id )
    using index enable;

