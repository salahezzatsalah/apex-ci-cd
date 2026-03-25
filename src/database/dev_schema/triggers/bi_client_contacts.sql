create or replace editionable trigger bi_client_contacts before
    insert on client_contacts
    for each row
begin
    if :new.contact_id is null then
        select
            client_contacts_seq.nextval
        into :new.contact_id
        from
            dual;

    end if;
end;
/

alter trigger bi_client_contacts enable;


-- sqlcl_snapshot {"hash":"f1fe08f52ca9b39901a653cfc0f647e54852f23e","type":"TRIGGER","name":"BI_CLIENT_CONTACTS","schemaName":"DEV_SCHEMA","sxml":""}