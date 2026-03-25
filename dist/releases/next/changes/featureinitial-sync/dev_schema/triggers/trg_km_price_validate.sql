-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464097295 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_km_price_validate.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_km_price_validate.sql:null:6658d1b4249ea2c937f97cc3633ba12f995aed88:create

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

