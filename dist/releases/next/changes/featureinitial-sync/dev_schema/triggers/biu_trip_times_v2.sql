-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464059703 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\biu_trip_times_v2.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/biu_trip_times_v2.sql:null:993d217b173411beeb59ddff3ba64f0b8e333482:create

create or replace editionable trigger biu_trip_times_v2 before
    insert or update on limo_trips_tracker_v2
    for each row
begin
    if inserting then
        if
            :new.status = 'ACTIVE'
            and :new.start_datetime is null
        then
            :new.start_datetime := systimestamp;
        end if;

    elsif updating then
        if
            :new.status = 'FINISHED'
            and :new.end_datetime is null
        then
            :new.end_datetime := systimestamp;
        end if;
    end if;
end;
/

alter trigger biu_trip_times_v2 enable;

