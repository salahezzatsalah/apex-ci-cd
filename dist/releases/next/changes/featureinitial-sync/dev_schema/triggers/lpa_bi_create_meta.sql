-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464072374 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\lpa_bi_create_meta.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/lpa_bi_create_meta.sql:null:4cf639dd131ef5c5af2afd88652c922804ccb530:create

create or replace editionable trigger lpa_bi_create_meta before
    insert on limo_product_assignments
    for each row
begin
    :new.created := current_timestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger lpa_bi_create_meta enable;

