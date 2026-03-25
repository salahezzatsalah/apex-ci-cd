create or replace editionable trigger trg_payments_bu before
    update on payments
    for each row
begin
    :new.updated := systimestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger trg_payments_bu enable;


-- sqlcl_snapshot {"hash":"c61944ebd883b0a7ebe8a043a345921f3250e131","type":"TRIGGER","name":"TRG_PAYMENTS_BU","schemaName":"WKSP_ELWAGHA50","sxml":""}