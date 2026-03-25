create or replace editionable trigger lpa_types_audit_trg before
    insert or update on limo_assignment_types
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

alter trigger lpa_types_audit_trg enable;


-- sqlcl_snapshot {"hash":"4ae0b624d4cf17d135ca6496132590f089c9b90e","type":"TRIGGER","name":"LPA_TYPES_AUDIT_TRG","schemaName":"WKSP_ELWAGHA50","sxml":""}