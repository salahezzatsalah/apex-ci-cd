-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464073948 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\lpa_protect_created.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/lpa_protect_created.sql:null:80cdeafefe3abe0efbec4b6d2938c73fbad6a381:create

create or replace editionable trigger lpa_protect_created before
    update on limo_product_assignments
    for each row
begin
    if :new.created <> :old.created
    or :new.created_by <> :old.created_by then
        raise_application_error(-20001, 'CREATED fields cannot be modified.');
    end if;
end;
/

alter trigger lpa_protect_created enable;

