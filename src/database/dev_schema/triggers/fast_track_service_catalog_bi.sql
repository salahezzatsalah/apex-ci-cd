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


-- sqlcl_snapshot {"hash":"c47b636a4bfc6c0339cb932dd7538cd97f6730bf","type":"TRIGGER","name":"FAST_TRACK_SERVICE_CATALOG_BI","schemaName":"DEV_SCHEMA","sxml":""}