-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464050499 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\bi_api_client_scopes.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/bi_api_client_scopes.sql:null:8af1ce79698bd216e3c9646704ee179fb39abf9b:create

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

