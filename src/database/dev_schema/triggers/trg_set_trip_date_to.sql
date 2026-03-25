create or replace editionable trigger trg_set_trip_date_to before
    insert or update on limo_products
    for each row
begin
    if :new.trip_type = 'TRANSFER' then
        :new.trip_date_to := :new.trip_date_from;
    end if;
end;
/

alter trigger trg_set_trip_date_to enable;


-- sqlcl_snapshot {"hash":"9dd7b3e1d77d0ceb33db1009517468a9183c66b2","type":"TRIGGER","name":"TRG_SET_TRIP_DATE_TO","schemaName":"DEV_SCHEMA","sxml":""}