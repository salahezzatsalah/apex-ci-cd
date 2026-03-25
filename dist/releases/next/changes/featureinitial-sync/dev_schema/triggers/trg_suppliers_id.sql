-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464116994 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_suppliers_id.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_suppliers_id.sql:null:2f26273509c2c16466ad1447d74ffbd999fa8a65:create

create or replace editionable trigger trg_suppliers_id before
    insert on suppliers
    for each row
    when ( new.supplier_id is null )
declare
    v_next number;
begin
    select
        seq_supplier_id.nextval
    into v_next
    from
        dual;

    :new.supplier_id := 'SUP-'
                        || lpad(v_next, 4, '0');
end;
/

alter trigger trg_suppliers_id enable;

