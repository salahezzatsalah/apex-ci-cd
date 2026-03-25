-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464084901 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_company_drivers_id.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_company_drivers_id.sql:null:ef7e541869ff225f8445cd5420512f36376e0dbf:create

create or replace editionable trigger trg_company_drivers_id before
    insert on company_drivers
    for each row
    when ( new.driver_id is null )
declare
    v_next number;
begin
    select
        seq_company_driver_id.nextval
    into v_next
    from
        dual;

    :new.driver_id := 'DRV-'
                      || lpad(v_next, 3, '0');
end;
/

alter trigger trg_company_drivers_id enable;

