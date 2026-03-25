create or replace editionable trigger main_res_biu before
    insert or update on main_reservations
    for each row
begin
    if inserting then
        if :new.main_res_id is null then
            :new.main_res_id := 'MR-'
                                || lpad(seq_main_res_id.nextval, 6, '0');
        end if;

        :new.created := systimestamp;
    end if;

    if updating then
        :new.updated := systimestamp;
    end if;
end;
/

alter trigger main_res_biu enable;


-- sqlcl_snapshot {"hash":"d52f2afe1281a69eaf042130293a51b91358fd6d","type":"TRIGGER","name":"MAIN_RES_BIU","schemaName":"DEV_SCHEMA","sxml":""}