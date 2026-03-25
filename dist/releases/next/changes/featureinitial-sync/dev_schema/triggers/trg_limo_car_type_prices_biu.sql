-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464100741 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_limo_car_type_prices_biu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_limo_car_type_prices_biu.sql:null:664ca83e70342fda1a54c725ef6c2179c62cf5e4:create

create or replace editionable trigger trg_limo_car_type_prices_biu before
    insert or update on limo_car_type_prices
    for each row
begin
  -- Default exchange rate for EGP
    if :new.currency = 'EGP' then
        :new.exchange_rate := 1;
    end if;

  -- Set created metadata on INSERT
    if inserting then
        :new.created := systimestamp;
        :new.created_by := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
    end if;

  -- Always set updated metadata
    :new.updated := systimestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );

  -- Touch parent table LIMO_CAR_TYPES on UPDATE
    if updating then
        update limo_car_types
        set
            updated = systimestamp,
            updated_by = nvl(
                apex_util.get_session_state('APP_USER_ID'),
                user
            )
        where
            car_type_id = :new.car_type_id;

    end if;

end;
/

alter trigger trg_limo_car_type_prices_biu enable;

