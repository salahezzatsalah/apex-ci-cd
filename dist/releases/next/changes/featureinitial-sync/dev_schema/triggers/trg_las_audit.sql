-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464098080 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_las_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_las_audit.sql:null:f0b03ccb409c23dc64d0ea58a0a9e19ccffea18f:create

create or replace editionable trigger trg_las_audit before
    insert or update on limo_add_services
    for each row
declare
    v_user_id varchar2(50);
begin
    v_user_id := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    if inserting then
        :new.created := systimestamp;
        :new.created_by := v_user_id;
    end if;

    :new.updated := systimestamp;
    :new.updated_by := v_user_id;
end;
/

alter trigger trg_las_audit enable;

