-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463946889 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\dbtools$execution_history.sql
-- sqlcl_snapshot src/database/dev_schema/tables/dbtools$execution_history.sql:null:17c2e70e6737dd03260ab313d21f64b9cb5fb420:create

create table dbtools$execution_history (
    id         number not null enable,
    hash       clob,
    created_by varchar2(255 byte),
    created_on timestamp(6) with time zone,
    updated_by varchar2(255 byte),
    updated_on timestamp(6) with time zone,
    statement  clob,
    times      number
);

alter table dbtools$execution_history
    add constraint dbtools$execution_history_pk primary key ( id )
        using index enable;

