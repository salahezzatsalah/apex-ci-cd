-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464116198 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_sublevel_limo_res_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_sublevel_limo_res_bi.sql:null:569ebb933985d8bd71acc01c7b2b4e893df12ff3:create

create or replace editionable trigger trg_sublevel_limo_res_bi before
    insert on sublevel_limo_res
    for each row
begin
    :new.created := systimestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    :new.updated := :new.created;
    :new.updated_by := :new.created_by;
end;
/

alter trigger trg_sublevel_limo_res_bi enable;

