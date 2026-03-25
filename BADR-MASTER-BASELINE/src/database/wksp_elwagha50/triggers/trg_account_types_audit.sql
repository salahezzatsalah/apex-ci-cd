create or replace editionable trigger trg_account_types_audit before
    insert or update on account_types
    for each row
declare
    v_user varchar2(100);
begin
  -- Prefer APEX :APP_USER_ID if available
    begin
        v_user := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
    exception
        when others then
            v_user := user;
    end;

    if inserting then
        :new.created := systimestamp;
        :new.created_by := v_user;
    end if;

    if updating then
        :new.updated := systimestamp;
        :new.updated_by := v_user;
    end if;

end;
/

alter trigger trg_account_types_audit enable;


-- sqlcl_snapshot {"hash":"796d3fefcdd822e1a30d7ba919a3de522518c75a","type":"TRIGGER","name":"TRG_ACCOUNT_TYPES_AUDIT","schemaName":"WKSP_ELWAGHA50","sxml":""}