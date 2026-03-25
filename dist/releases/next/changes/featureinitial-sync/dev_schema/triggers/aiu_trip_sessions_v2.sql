-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464049651 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\aiu_trip_sessions_v2.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/aiu_trip_sessions_v2.sql:null:1cece272191ee22a85ca645ff828671faa44914e:create

create or replace editionable trigger aiu_trip_sessions_v2 after
    insert or update on limo_trips_tracker_v2
    for each row
declare
    v_session_type varchar2(10);
    v_user_id      varchar2(100) := apex_util.get_session_state('APP_USER_ID');
begin
    if inserting then
        if :new.status = 'ACTIVE' then
            v_session_type := 'START';
        elsif :new.status = 'PAUSED' then
            v_session_type := 'PAUSE';
        end if;
    elsif updating then
        if :new.status != :old.status then
            case :new.status
                when 'ACTIVE' then
                    v_session_type := 'RESUME';
                when 'PAUSED' then
                    v_session_type := 'PAUSE';
                when 'FINISHED' then
                    v_session_type := 'FINISH';
                else
                    v_session_type := null;
            end case;

        end if;
    end if;

    if v_session_type is not null then
        insert into limo_trip_sessions (
            trip_id,
            session_type,
            started_at,
            created_by
        ) values ( :new.trip_id,
                   v_session_type,
                   systimestamp,
                   v_user_id );

    end if;

end;
/

alter trigger aiu_trip_sessions_v2 enable;

