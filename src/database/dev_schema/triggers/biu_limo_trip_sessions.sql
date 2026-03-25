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


-- sqlcl_snapshot {"hash":"612dd901495e14064dbd4d92ee114d724247fdba","type":"TRIGGER","name":"BIU_LIMO_TRIP_SESSIONS","schemaName":"DEV_SCHEMA","sxml":""}