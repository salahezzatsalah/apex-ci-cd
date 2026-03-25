-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464085767 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_currencies_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_currencies_audit.sql:null:cce9c847db2fec01d04dee4c536d458e146dd150:create

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

