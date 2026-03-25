create or replace editionable trigger lpa_bu_update_meta before
    update on limo_product_assignments
    for each row
begin
    :new.updated := current_timestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger lpa_bu_update_meta enable;


-- sqlcl_snapshot {"hash":"6a1141031061e574dc5dbafd8248aef1a38addf2","type":"TRIGGER","name":"LPA_BU_UPDATE_META","schemaName":"WKSP_ELWAGHA50","sxml":""}