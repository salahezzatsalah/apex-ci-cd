-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464099951 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_lctkp_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_lctkp_bi.sql:null:8715b71e3f84a29782210b9c0dec84a4c98e587b:create

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

