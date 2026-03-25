-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464060618 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\bs_employees_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/bs_employees_bi.sql:null:2d510bc893e008a10bbdef2952ea7004887cd9b3:create

create or replace editionable trigger bs_employees_bi before
    insert on bs_employees
    for each row
begin
    if :new.id is null then
        :new.id := 'EMP-'
                   || lpad(bs_employees_seq.nextval, 5, '0');

    end if;
end;
/

alter trigger bs_employees_bi enable;

