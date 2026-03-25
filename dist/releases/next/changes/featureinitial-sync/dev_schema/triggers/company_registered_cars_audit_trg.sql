-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464063333 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\company_registered_cars_audit_trg.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/company_registered_cars_audit_trg.sql:null:ab1cedc1a837767cad6f17d6d95e532dec6ac92b:create

create or replace editionable trigger company_registered_cars_audit_trg before
    insert or update on company_registered_cars
    for each row
begin
    if inserting then
        :new.created := current_timestamp;
        :new.created_by := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
    end if;

    :new.updated := current_timestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger company_registered_cars_audit_trg enable;

