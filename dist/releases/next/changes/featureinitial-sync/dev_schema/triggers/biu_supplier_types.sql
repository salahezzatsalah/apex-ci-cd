-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464057912 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\biu_supplier_types.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/biu_supplier_types.sql:null:71fead09356f8e3e811d1f2817d72511fb6349ff:create

create or replace editionable trigger biu_supplier_types before
    insert or update on supplier_types
    for each row
declare
    v_user_id varchar2(100);
begin
  -- Get current user ID from session or fallback
    v_user_id := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    if inserting then
        :new.created := systimestamp;
        :new.created_by := v_user_id;
    end if;

    if inserting
    or updating then
        :new.updated := systimestamp;
        :new.updated_by := v_user_id;
    end if;

end;
/

alter trigger biu_supplier_types enable;

