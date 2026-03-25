-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464087579 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_default_currency_update.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_default_currency_update.sql:null:ece973e6d8d71cf6628b8cb10f6d07e9df772454:create

create or replace editionable trigger trg_default_currency_update before
    update on default_currency
    for each row
begin
    :new.set_date := sysdate;
    :new.set_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger trg_default_currency_update enable;

