create or replace editionable trigger trg_default_currency_update before
    update on default_currency
    for each row
begin
    :new.set_date := sysdate;
    :new.set_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger trg_default_currency_update enable;


-- sqlcl_snapshot {"hash":"0c4e74f6ad18ce90297a9ddceb8f35c983f15232","type":"TRIGGER","name":"TRG_DEFAULT_CURRENCY_UPDATE","schemaName":"WKSP_ELWAGHA50","sxml":""}