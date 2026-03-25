create or replace editionable trigger bi_client_events before
    insert on client_events
    for each row
begin
    if :new.event_id is null then
        select
            client_events_seq.nextval
        into :new.event_id
        from
            dual;

    end if;
end;
/

alter trigger bi_client_events enable;


-- sqlcl_snapshot {"hash":"00f048cf3c9ada1f04933ea2a066ffe31eb36252","type":"TRIGGER","name":"BI_CLIENT_EVENTS","schemaName":"WKSP_ELWAGHA50","sxml":""}