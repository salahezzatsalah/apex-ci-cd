-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464046121 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\whatsapp_messages.sql
-- sqlcl_snapshot src/database/dev_schema/tables/whatsapp_messages.sql:null:fc2b6a2fcb20310e8e8400dda57f3a238a18f363:create

create table whatsapp_messages (
    message_id      varchar2(100 byte),
    client_id       varchar2(36 byte),
    phone_number    varchar2(30 byte),
    direction       varchar2(5 byte),
    message_type    varchar2(20 byte),
    message_text    clob,
    provider        varchar2(30 byte),
    provider_status varchar2(30 byte),
    sent_at         timestamp(6) with time zone,
    received_at     timestamp(6) with time zone,
    raw_payload     clob
);

alter table whatsapp_messages add primary key ( message_id )
    using index enable;

