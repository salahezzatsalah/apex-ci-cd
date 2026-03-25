create or replace editionable trigger biu_company_drivers_audit before
    insert or update on company_drivers
    for each row
begin
    if inserting then
        :new.created := systimestamp;
        :new.created_by := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
    end if;

    :new.updated := systimestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger biu_company_drivers_audit enable;


-- sqlcl_snapshot {"hash":"ce0c3b56006cb16a64dad333505458fe29c39a6d","type":"TRIGGER","name":"BIU_COMPANY_DRIVERS_AUDIT","schemaName":"WKSP_ELWAGHA50","sxml":""}