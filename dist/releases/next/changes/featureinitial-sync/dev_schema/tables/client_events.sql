-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463936653 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\client_events.sql
-- sqlcl_snapshot src/database/dev_schema/tables/client_events.sql:null:cf1818805551af29286a6c9b8b01fc8942b7f342:create

create table client_events (
    event_id        number,
    client_id       varchar2(36 byte),
    event_type      varchar2(30 byte),
    event_source    varchar2(30 byte),
    related_entity  varchar2(30 byte),
    related_id      varchar2(50 byte),
    event_date      date default sysdate,
    event_data_json clob,
    created_by      varchar2(50 byte)
);

alter table client_events add primary key ( event_id )
    using index enable;

