-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464111132 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_payments_bu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_payments_bu.sql:null:8334daf047a6784f74f6a5567a39fe2a3edd0985:create

create or replace editionable trigger trg_payments_bu before
    update on payments
    for each row
begin
    :new.updated := systimestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger trg_payments_bu enable;

