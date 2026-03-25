-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464115370 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_set_trip_date_to.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_set_trip_date_to.sql:null:50ee3935eb59d61482db61f67c8a8a36f62ae745:create

create or replace editionable trigger trg_set_trip_date_to before
    insert or update on limo_products
    for each row
begin
    if :new.trip_type = 'TRANSFER' then
        :new.trip_date_to := :new.trip_date_from;
    end if;
end;
/

alter trigger trg_set_trip_date_to enable;

