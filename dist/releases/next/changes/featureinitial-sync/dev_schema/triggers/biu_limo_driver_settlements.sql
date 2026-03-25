-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464055365 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\biu_limo_driver_settlements.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/biu_limo_driver_settlements.sql:null:3085f22af3869fdd1d8c595c27d4f2dba57658ea:create

create or replace editionable trigger biu_limo_driver_settlements before
    insert on limo_driver_settlements
    for each row
begin
    if :new.id is null then
        select
            'SETTLE-'
            || lpad(seq_limo_settlements.nextval, 6, '0')
        into :new.id
        from
            dual;

    end if;
end;
/

alter trigger biu_limo_driver_settlements enable;

