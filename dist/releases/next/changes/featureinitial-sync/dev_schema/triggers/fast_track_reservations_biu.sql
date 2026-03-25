-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464065977 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\fast_track_reservations_biu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/fast_track_reservations_biu.sql:null:4cc71f3b61ecc635ebc387ac81f7ed4d94db0fd7:create

create or replace editionable trigger fast_track_reservations_biu before
    insert or update on fast_track_reservations
    for each row
begin
    if inserting then
        if :new.reservation_id is null then
            :new.reservation_id := 'FT-'
                                   || lpad(seq_fast_track_reservations.nextval, 6, '0');
        end if;

        :new.created := current_timestamp;
        :new.created_by := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
        if :new.status is null then
            :new.status := 'PENDING';
        end if;

    end if;

    :new.updated := current_timestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger fast_track_reservations_biu enable;

