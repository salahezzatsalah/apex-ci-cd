create or replace editionable trigger trg_km_price_validate before
    insert or update on limo_car_type_km_prices
    for each row
declare
    v_cnt number;
begin
    select
        count(*)
    into v_cnt
    from
        limo_car_type_km_prices
    where
            car_type_id = :new.car_type_id
        and is_active = 'Y'
        and price_id <> nvl(:new.price_id,
                            'X')
        and ( nvl(:new.effective_from,
                  systimestamp) between nvl(effective_from, systimestamp) and nvl(effective_to, systimestamp + 9999) );

    if v_cnt > 0 then
        raise_application_error(-20001, 'Overlapping KM price detected');
    end if;
end;
/

alter trigger trg_km_price_validate disable;


-- sqlcl_snapshot {"hash":"c8083bdffdc9fa397040f63b6e36fb06694e32de","type":"TRIGGER","name":"TRG_KM_PRICE_VALIDATE","schemaName":"DEV_SCHEMA","sxml":""}