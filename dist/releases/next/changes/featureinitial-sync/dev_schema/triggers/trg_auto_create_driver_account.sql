-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464082122 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_auto_create_driver_account.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_auto_create_driver_account.sql:null:4618bd5d217a6e158cd44c1ea95b5606d0f2863a:create

create or replace editionable trigger trg_auto_create_driver_account after
    insert on company_drivers
    for each row
begin
    create_driver_egp_account(:new.driver_id,
                              :new.driver_name);
end;
/

alter trigger trg_auto_create_driver_account enable;

