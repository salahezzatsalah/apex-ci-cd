-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464101505 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_limo_car_types_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_limo_car_types_bi.sql:null:888dbc24f57aba551eb45f0b1e7642bcf584b99a:create

create or replace editionable trigger trg_limo_car_types_bi before
    insert on limo_car_types
    for each row
begin
    if :new.car_type_id is null then
        :new.car_type_id := 'CAR-'
                            || lpad(limo_car_type_seq.nextval, 5, '0');
    end if;

    :new.created := systimestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );

  -- initialize UPDATED fields on insert as well
    :new.updated := :new.created;
    :new.updated_by := :new.created_by;
end;
/

alter trigger trg_limo_car_types_bi enable;

