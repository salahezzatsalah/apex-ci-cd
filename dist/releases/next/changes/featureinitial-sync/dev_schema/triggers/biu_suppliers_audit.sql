-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464058814 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\biu_suppliers_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/biu_suppliers_audit.sql:null:91d5f9e6fe12150498a597b32a4f9dc18402bdb4:create

create or replace editionable trigger biu_suppliers_audit before
    insert or update on suppliers
    for each row
begin
    if inserting then
        :new.created := systimestamp;
        :new.created_by := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
    end if;

    :new.updated := systimestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger biu_suppliers_audit enable;

