-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464073137 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\lpa_bu_update_meta.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/lpa_bu_update_meta.sql:null:28136b03e69ccb06e2f632172c91efa75c5f8cdd:create

create or replace editionable trigger lpa_bu_update_meta before
    update on limo_product_assignments
    for each row
begin
    :new.updated := current_timestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger lpa_bu_update_meta enable;

