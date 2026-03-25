-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464066775 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\fast_track_service_catalog_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/fast_track_service_catalog_bi.sql:null:d38f00a51784b9e9310c6b35f9b71d8b5904a8fe:create

create or replace editionable trigger fast_track_service_catalog_bi before
    insert on fast_track_service_catalog
    for each row
begin
    if :new.service_id is null then
        :new.service_id := 'FTSERV-'
                           || lpad(seq_fast_track_service_catalog.nextval, 5, '0');
    end if;

    if :new.created is null then
        :new.created := current_timestamp;
    end if;

end;
/

alter trigger fast_track_service_catalog_bi enable;

