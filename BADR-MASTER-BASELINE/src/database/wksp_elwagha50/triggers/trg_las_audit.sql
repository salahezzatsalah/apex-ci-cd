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


-- sqlcl_snapshot {"hash":"f3afcaa1ae4965b173b8c1597419d5544143068c","type":"TRIGGER","name":"TRG_LAS_AUDIT","schemaName":"WKSP_ELWAGHA50","sxml":""}