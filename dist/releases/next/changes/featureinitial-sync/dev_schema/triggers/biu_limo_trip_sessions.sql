-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464057093 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\biu_limo_trip_sessions.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/biu_limo_trip_sessions.sql:null:617b1d32b87084901bd842768066e18df9525d28:create

create or replace editionable trigger biu_limo_trip_sessions before
    insert on limo_trip_sessions
    for each row
begin
    if :new.session_id is null then
        :new.session_id := 'TRIPSESS-'
                           || to_char(seq_limo_trip_sessions.nextval, 'FM000000');
    end if;

    if :new.created is null then
        :new.created := sysdate;
    end if;

    if :new.created_by is null then
        :new.created_by := sys_context('APEX$SESSION', 'APP_USER_ID');
    end if;

end;
/

alter trigger biu_limo_trip_sessions enable;

