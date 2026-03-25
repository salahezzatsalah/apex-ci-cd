-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464076314 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\reservation_interactions_log_biu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/reservation_interactions_log_biu.sql:null:22ac0fe3f31024cd58c9fd3510d25e921f2b99ae:create

create or replace editionable trigger reservation_interactions_log_biu before
    insert or update on reservation_interactions_log
    for each row
begin
    :new.page_rendered := systimestamp;

    -- Get current logged-in user ID from APEX session state
    if :new.user_id is null then
        :new.user_id := to_number ( apex_util.get_session_state('APP_USER_ID') );
    end if;

end;
/

alter trigger reservation_interactions_log_biu enable;

