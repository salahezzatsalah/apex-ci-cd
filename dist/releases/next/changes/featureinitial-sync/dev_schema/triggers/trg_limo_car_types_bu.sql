-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464102277 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_limo_car_types_bu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_limo_car_types_bu.sql:null:5a69217393ed6e0816d6e2fd3b36018b5edccbd5:create

create or replace editionable trigger trg_limo_car_types_bu before
    update on limo_car_types
    for each row
begin
    :new.updated := systimestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger trg_limo_car_types_bu enable;

