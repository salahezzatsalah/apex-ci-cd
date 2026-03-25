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


-- sqlcl_snapshot {"hash":"13ee2893fefcd7f5e2adac21a045cc175e44e1dd","type":"TRIGGER","name":"FAST_TRACK_COMMISSION_RULES_BI","schemaName":"DEV_SCHEMA","sxml":""}