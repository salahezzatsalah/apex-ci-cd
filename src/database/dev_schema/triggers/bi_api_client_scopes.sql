create or replace editionable trigger bi_api_client_scopes before
    insert on api_client_scopes
    for each row
begin
    if :new.id is null then
        select
            api_client_scopes_seq.nextval
        into :new.id
        from
            dual;

    end if;
end;
/

alter trigger bi_api_client_scopes enable;


-- sqlcl_snapshot {"hash":"b350b2958db61c53318e3ed7e0ed781df9d905d0","type":"TRIGGER","name":"BI_API_CLIENT_SCOPES","schemaName":"DEV_SCHEMA","sxml":""}