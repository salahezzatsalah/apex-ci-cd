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


-- sqlcl_snapshot {"hash":"5608dfbf7092452b95e7dbeb27d0e1ff8267657f","type":"TRIGGER","name":"BIU_TRIP_TIMES_V2","schemaName":"DEV_SCHEMA","sxml":""}