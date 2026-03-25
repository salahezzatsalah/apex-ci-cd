-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464046932 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\whatsapp_webhook_log.sql
-- sqlcl_snapshot src/database/dev_schema/tables/whatsapp_webhook_log.sql:null:fd8d6bc6d859a4cbb9e4fb36c018b9c7343b62a1:create

create table whatsapp_webhook_log (
    id          number generated always as identity not null enable,
    received_at timestamp(6) default current_timestamp,
    payload     clob
);

alter table whatsapp_webhook_log add primary key ( id )
    using index enable;

