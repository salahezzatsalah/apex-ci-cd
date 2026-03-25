create or replace editionable trigger trg_currencies_audit before
    insert or update on currencies
    for each row
declare
    v_user varchar2(100) := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
begin
    if inserting then
        :new.created := systimestamp;
        :new.created_by := v_user;
    end if;
end;
/

alter trigger trg_currencies_audit enable;


-- sqlcl_snapshot {"hash":"f49c68439c32a9a6f6982006d5693664d9ee0075","type":"TRIGGER","name":"TRG_CURRENCIES_AUDIT","schemaName":"WKSP_ELWAGHA50","sxml":""}