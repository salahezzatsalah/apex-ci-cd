-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464133126 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_limo_car_type_price_multi_curr.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_limo_car_type_price_multi_curr.sql:null:7783d7c8489be5be7c09da2837910aded169f1e8:create

create or replace force editionable view vw_limo_car_type_price_multi_curr (
    car_type_id,
    prices_by_currency_json
) as
    select
        cp.car_type_id,
        json_arrayagg(
            json_object(
                'currency' value cr.currency_code,
                        'currency_name_ar' value cr.currency_name_ar,
                        'currency_name_en' value cr.currency_name_en,
                        'symbol' value cr.symbol,
                        'base_price' value cp.price_per_trip,
                        'base_currency' value cp.currency,
                        'exchange_rate' value cr.exchange_rate,
                        'converted_price' value round(cp.price_per_trip * base_rate.exchange_rate / cr.exchange_rate, 2),
                        'rate_date' value to_char(cr.rate_date, 'YYYY-MM-DD')
            )
        returning clob) as prices_by_currency_json
    from
             vw_limo_car_type_current_price cp
        join v_latest_currency_rates base_rate on base_rate.currency_code = cp.currency
        join v_latest_currency_rates cr on 1 = 1
    group by
        cp.car_type_id,
        cp.price_per_trip,
        cp.currency,
        base_rate.exchange_rate;

