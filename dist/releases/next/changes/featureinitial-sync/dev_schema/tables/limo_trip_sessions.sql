-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464004828 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_trip_sessions.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_trip_sessions.sql:null:f2b2d0bab4c580a852cc1c0d3d518eafb24df62d:create

create table limo_trip_sessions (
    session_id   varchar2(30 byte),
    trip_id      varchar2(30 byte),
    session_type varchar2(10 byte),
    created_by   varchar2(100 byte),
    started_at   timestamp(6) with time zone,
    ended_at     timestamp(6) with time zone,
    created      timestamp(6) with time zone
);

alter table limo_trip_sessions add primary key ( session_id )
    using index enable;

