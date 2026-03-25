create or replace force editionable view vw_limo_car_type_current_km_price (
    car_type_id,
    price_per_km,
    currency
) as
    select
        p.car_type_id,
        p.price_per_km,
        p.currency
    from
        limo_car_type_km_prices p
    where
        p.is_active = 'Y';


-- sqlcl_snapshot {"hash":"06830a5ccf11797b34f9a2e1ee455ef0e853197d","type":"VIEW","name":"VW_LIMO_CAR_TYPE_CURRENT_KM_PRICE","schemaName":"DEV_SCHEMA","sxml":""}