create or replace editionable trigger biu_supplier_types before
    insert or update on supplier_types
    for each row
declare
    v_user_id varchar2(100);
begin
  -- Get current user ID from session or fallback
    v_user_id := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    if inserting then
        :new.created := systimestamp;
        :new.created_by := v_user_id;
    end if;

    if inserting
    or updating then
        :new.updated := systimestamp;
        :new.updated_by := v_user_id;
    end if;

end;
/

alter trigger biu_supplier_types enable;


-- sqlcl_snapshot {"hash":"03418ac98254aab84f1afc157dfdb809b56ab9e4","type":"TRIGGER","name":"BIU_SUPPLIER_TYPES","schemaName":"WKSP_ELWAGHA50","sxml":""}