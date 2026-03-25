-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464052454 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\bi_client_events.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/bi_client_events.sql:null:29d1cf889a5e04c671b93624db01ed25c664ac69:create

create or replace editionable trigger bi_client_events before
    insert on client_events
    for each row
begin
    if :new.event_id is null then
        select
            client_events_seq.nextval
        into :new.event_id
        from
            dual;

    end if;
end;
/

alter trigger bi_client_events enable;

