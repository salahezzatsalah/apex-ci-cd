create or replace editionable trigger biu_suppliers_audit before
    insert or update on suppliers
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

alter trigger biu_suppliers_audit enable;


-- sqlcl_snapshot {"hash":"295dac22596d36d5121afcdb170297e1d0c59a1f","type":"TRIGGER","name":"BIU_SUPPLIERS_AUDIT","schemaName":"WKSP_ELWAGHA50","sxml":""}