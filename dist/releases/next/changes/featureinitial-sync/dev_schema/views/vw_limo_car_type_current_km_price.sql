-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464131523 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_limo_car_type_current_km_price.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_limo_car_type_current_km_price.sql:null:06830a5ccf11797b34f9a2e1ee455ef0e853197d:create

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

