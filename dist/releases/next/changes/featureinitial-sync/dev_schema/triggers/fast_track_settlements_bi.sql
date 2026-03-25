-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464068383 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\fast_track_settlements_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/fast_track_settlements_bi.sql:null:a66530169856a1a252375368307057ab8182825a:create

create or replace editionable trigger fast_track_settlements_bi before
    insert on fast_track_settlements
    for each row
begin
    if :new.settlement_id is null then
        :new.settlement_id := 'FTSET-'
                              || lpad(seq_fast_track_settlements.nextval, 6, '0');
    end if;

    if :new.created is null then
        :new.created := current_timestamp;
    end if;

end;
/

alter trigger fast_track_settlements_bi enable;

