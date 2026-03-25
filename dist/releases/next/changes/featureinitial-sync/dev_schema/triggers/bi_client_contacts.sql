-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464051621 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\bi_client_contacts.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/bi_client_contacts.sql:null:d82e9ae158eda7e4f38d363a52691c44513dfe92:create

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

