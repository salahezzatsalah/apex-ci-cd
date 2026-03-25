-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464009848 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\notifications.sql
-- sqlcl_snapshot src/database/dev_schema/tables/notifications.sql:null:a892af0ba83c5004c61e35a4f5a1e847c1a93fa6:create

create table notifications (
    notification_id varchar2(32 byte),
    user_id         varchar2(32 byte),
    title           varchar2(255 byte),
    body            varchar2(1000 byte),
    type            varchar2(50 byte),
    status          varchar2(20 byte) default 'UNREAD',
    entity_type     varchar2(50 byte),
    entity_id       varchar2(50 byte),
    action_screen   varchar2(100 byte),
    action_params   varchar2(1000 byte),
    created_at      timestamp(6) default current_timestamp,
    read_at         timestamp(6),
    is_deleted      char(1 byte) default 'N'
);

alter table notifications add primary key ( notification_id )
    using index enable;

