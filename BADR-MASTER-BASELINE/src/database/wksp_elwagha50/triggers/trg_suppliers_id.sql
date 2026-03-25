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


-- sqlcl_snapshot {"hash":"5eeed668041d213946324444d4455198d1bd3111","type":"TRIGGER","name":"TRG_SUPPLIERS_ID","schemaName":"WKSP_ELWAGHA50","sxml":""}