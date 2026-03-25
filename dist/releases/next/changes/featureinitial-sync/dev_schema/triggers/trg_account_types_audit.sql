-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464078741 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_account_types_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_account_types_audit.sql:null:e26da4e0ea62c80bda035469734277df8f952179:create

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

