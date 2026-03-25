-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464067595 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\fast_track_settlement_details_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/fast_track_settlement_details_bi.sql:null:0fbe2e3c7458a6ddf40eb2ed3f238110d2c0c047:create

create or replace editionable trigger fast_track_settlement_details_bi before
    insert on fast_track_settlement_details
    for each row
begin
    if :new.detail_id is null then
        :new.detail_id := 'FTSD-'
                          || lpad(seq_fast_track_settlement_details.nextval, 6, '0');
    end if;

    if :new.created is null then
        :new.created := current_timestamp;
    end if;

end;
/

alter trigger fast_track_settlement_details_bi enable;

