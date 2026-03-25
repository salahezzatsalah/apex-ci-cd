-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464065024 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\fast_track_commission_rules_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/fast_track_commission_rules_bi.sql:null:100fd4903c923b50dc6e231d940b8f3a5a5913bf:create

create or replace editionable trigger fast_track_commission_rules_bi before
    insert on fast_track_commission_rules
    for each row
begin
    if :new.rule_id is null then
        :new.rule_id := 'FTCR-'
                        || lpad(seq_fast_track_commission_rules.nextval, 6, '0');
    end if;

    if :new.created is null then
        :new.created := current_timestamp;
    end if;

end;
/

alter trigger fast_track_commission_rules_bi enable;

