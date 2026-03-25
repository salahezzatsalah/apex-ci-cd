-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464071563 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\lpa_bi_assignment_id.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/lpa_bi_assignment_id.sql:null:3e5b2cd8405ab325ca49690f8c9cb398521d1b3c:create

create or replace editionable trigger lpa_bi_assignment_id before
    insert on limo_product_assignments
    for each row
begin
    if :new.assignment_id is null then
        :new.assignment_id := 'LPA-' || limo_assign_id_seq.nextval;
    end if;
end;
/

alter trigger lpa_bi_assignment_id enable;

