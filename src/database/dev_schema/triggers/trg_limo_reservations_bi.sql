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


-- sqlcl_snapshot {"hash":"30764162b201c3649dde706399141cc546329ff6","type":"TRIGGER","name":"TRG_LIMO_RESERVATIONS_BI","schemaName":"DEV_SCHEMA","sxml":""}