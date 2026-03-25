-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464083068 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_bs_departments_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_bs_departments_bi.sql:null:0e89520893a95c8f5767b6324feca41124633c24:create

create or replace editionable trigger trg_bs_departments_bi before
    insert on bs_departments
    for each row
begin
    if :new.id is null then
        select
            seq_bs_departments.nextval
        into :new.id
        from
            dual;

    end if;
end;
/

alter trigger trg_bs_departments_bi enable;

