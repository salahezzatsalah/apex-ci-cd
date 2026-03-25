create or replace editionable trigger lpa_bi_create_meta before
    insert on limo_product_assignments
    for each row
begin
    :new.created := current_timestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger lpa_bi_create_meta enable;


-- sqlcl_snapshot {"hash":"b5bc5b4aaad494c58f6fa1aeded4c6e59739369a","type":"TRIGGER","name":"LPA_BI_CREATE_META","schemaName":"WKSP_ELWAGHA50","sxml":""}