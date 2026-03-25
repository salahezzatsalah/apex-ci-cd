-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464103860 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_limo_reservations_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_limo_reservations_bi.sql:null:d344c73211f6c9e97c391599c6f690cc04037c0a:create

create or replace editionable trigger trg_limo_reservations_bi before
    insert on limo_reservations
    for each row
begin
    if :new.reservation_id is null then
        :new.reservation_id := 'LR-' || limo_reservation_seq.nextval;
    end if;

    :new.created := systimestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    :new.updated := :new.created;
    :new.updated_by := :new.created_by;
end;
/

alter trigger trg_limo_reservations_bi enable;

