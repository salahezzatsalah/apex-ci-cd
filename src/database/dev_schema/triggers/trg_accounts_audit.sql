create or replace editionable trigger trg_accounts_audit before
    insert or update on accounts
    for each row
declare
    v_user varchar2(100);
begin
  -- Prefer APEX session user if available
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

alter trigger trg_accounts_audit enable;


-- sqlcl_snapshot {"hash":"b67547d9239909cbef354c593d254aae59950083","type":"TRIGGER","name":"TRG_ACCOUNTS_AUDIT","schemaName":"DEV_SCHEMA","sxml":""}