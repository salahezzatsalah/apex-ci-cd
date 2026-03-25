-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464079610 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_accounts_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_accounts_audit.sql:null:2849e9c3b56704d3f31dda3e67d9a18bfa812d34:create

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

