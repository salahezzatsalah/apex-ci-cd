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


-- sqlcl_snapshot {"hash":"4e3675bc95391b6c39941b333dcb6d63609e3128","type":"TRIGGER","name":"TRG_SUBLEVEL_LIMO_RES_BI","schemaName":"DEV_SCHEMA","sxml":""}