-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464099173 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_las_id.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_las_id.sql:null:6ea50393cdfe4c53f3e1404fdb1b4dbfbb637592:create

create or replace editionable trigger trg_las_id before
    insert on limo_add_services
    for each row
begin
    if :new.add_service_id is null then
        :new.add_service_id := 'ADDSVC-'
                               || to_char(seq_limo_add_service.nextval, 'FM000000');
    end if;
end;
/

alter trigger trg_las_id enable;

