-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464074723 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\lpa_types_audit_trg.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/lpa_types_audit_trg.sql:null:436d2a87a4b9bc00add36911b34a65deab2235b8:create

create or replace editionable trigger lpa_types_audit_trg before
    insert or update on limo_assignment_types
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

alter trigger lpa_types_audit_trg enable;

