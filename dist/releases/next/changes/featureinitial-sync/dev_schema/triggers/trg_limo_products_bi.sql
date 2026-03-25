-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464103086 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_limo_products_bi.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_limo_products_bi.sql:null:d7113ea5c87afc1a8d5d626e18b89d4ce7f9b995:create

create or replace editionable trigger trg_limo_products_bi before
    insert on limo_products
    for each row
begin
    if :new.product_id is null then
        :new.product_id := 'PL-' || limo_product_seq.nextval;
    end if;

    :new.created := systimestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
    :new.updated := :new.created;
    :new.updated_by := :new.created_by;
end;
/

alter trigger trg_limo_products_bi enable;

