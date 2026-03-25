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


-- sqlcl_snapshot {"hash":"7f4ef5223840125105bc0e5fb79662d4d6bdefcc","type":"TRIGGER","name":"TRG_LTXP_AUDIT","schemaName":"DEV_SCHEMA","sxml":""}