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


-- sqlcl_snapshot {"hash":"843359471224b637d40ff125baaa9bac7f26c00a","type":"TRIGGER","name":"FAST_TRACK_SETTLEMENTS_BI","schemaName":"DEV_SCHEMA","sxml":""}