-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464108701 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_ltxp_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_ltxp_audit.sql:null:5091f7430ef5db2d2fbff13038d3b343fdf830c3:create

create or replace editionable trigger trg_ltxp_audit before
    insert or update on limo_trip_expenses
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

alter trigger trg_ltxp_audit enable;

