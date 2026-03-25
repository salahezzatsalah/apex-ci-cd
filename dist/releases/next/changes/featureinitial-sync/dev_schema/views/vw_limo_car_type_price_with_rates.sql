-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464133536 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_limo_car_type_price_with_rates.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_limo_car_type_price_with_rates.sql:null:cc5470de73c971c0b0f54827e7bf58534b47d83e:create

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

