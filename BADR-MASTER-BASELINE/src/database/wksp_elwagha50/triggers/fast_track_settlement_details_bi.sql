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


-- sqlcl_snapshot {"hash":"fef02e6e2d237ab2b1e3665ca35f652404eccaa8","type":"TRIGGER","name":"FAST_TRACK_SETTLEMENT_DETAILS_BI","schemaName":"WKSP_ELWAGHA50","sxml":""}