create or replace editionable trigger trg_lctkp_bi before
    insert on limo_car_type_km_prices
    for each row
begin
    if :new.price_id is null then
        :new.price_id := 'KMP-'
                         || lpad(seq_limo_car_type_km_price.nextval, 6, '0');
    end if;

    :new.created := systimestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    :new.updated := :new.created;
    :new.updated_by := :new.created_by;
end;
/

alter trigger trg_lctkp_bi enable;


-- sqlcl_snapshot {"hash":"a6ed0708e492ca14141180ed49337709e101b94a","type":"TRIGGER","name":"TRG_LCTKP_BI","schemaName":"WKSP_ELWAGHA50","sxml":""}