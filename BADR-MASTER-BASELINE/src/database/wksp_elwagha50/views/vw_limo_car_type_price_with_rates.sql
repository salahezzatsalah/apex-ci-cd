create or replace force editionable view vw_limo_car_type_price_with_rates (
    car_type_id,
    price_per_trip,
    currency,
    exchange_rate,
    rate_date,
    price_egp
) as
    select
        cp.car_type_id,
        cp.price_per_trip,
        cp.currency,
        cr.exchange_rate,
        cr.rate_date,
        round(cp.price_per_trip * cr.exchange_rate, 2) as price_egp
    from
             vw_limo_car_type_current_price cp
        join v_latest_currency_rates cr on cr.currency_code = cp.currency;


-- sqlcl_snapshot {"hash":"cc5470de73c971c0b0f54827e7bf58534b47d83e","type":"VIEW","name":"VW_LIMO_CAR_TYPE_PRICE_WITH_RATES","schemaName":"WKSP_ELWAGHA50","sxml":""}