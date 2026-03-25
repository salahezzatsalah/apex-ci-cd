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


-- sqlcl_snapshot {"hash":"9e2e13efad53a94476639601346db33e94a36359","type":"TRIGGER","name":"RESERVATION_INTERACTIONS_LOG_BIU","schemaName":"WKSP_ELWAGHA50","sxml":""}