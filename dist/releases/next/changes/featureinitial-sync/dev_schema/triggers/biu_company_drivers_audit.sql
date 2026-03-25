-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464053432 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\biu_company_drivers_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/biu_company_drivers_audit.sql:null:d108119e9a18ca083e6c41ce78d8fdf836d300ac:create

create or replace editionable trigger biu_company_drivers_audit before
    insert or update on company_drivers
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

alter trigger biu_company_drivers_audit enable;

