create or replace editionable trigger subft_res_biu before
    insert or update on sublevel_fast_track_res
    for each row
declare
    v_user varchar2(200);
begin
    v_user := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    if inserting then
        if :new.sub_res_id is null then
            :new.sub_res_id := 'FT-'
                               || lpad(seq_subft_sub_res.nextval, 6, '0');
        end if;

        :new.created := systimestamp;
        :new.created_by := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
    end if;

    if updating then
        :new.updated := systimestamp;
        :new.updated_by := v_user;
    end if;

end;
/

alter trigger subft_res_biu enable;


-- sqlcl_snapshot {"hash":"552083b2f985e6e3a5a6efebe1fd29c48bf4da29","type":"TRIGGER","name":"SUBFT_RES_BIU","schemaName":"WKSP_ELWAGHA50","sxml":""}