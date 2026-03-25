create or replace editionable trigger company_registered_cars_audit_trg before
    insert or update on company_registered_cars
    for each row
begin
    if inserting then
        :new.created := current_timestamp;
        :new.created_by := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
    end if;

    :new.updated := current_timestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger company_registered_cars_audit_trg enable;


-- sqlcl_snapshot {"hash":"f77720843ee1e6e0c27a0b9e04fa4fc40e2af8f5","type":"TRIGGER","name":"COMPANY_REGISTERED_CARS_AUDIT_TRG","schemaName":"DEV_SCHEMA","sxml":""}