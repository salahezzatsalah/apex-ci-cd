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


-- sqlcl_snapshot {"hash":"eb0a1ee0a024b242926a4829eca3fbb75c2c5732","type":"TRIGGER","name":"TRG_LIMO_PRODUCTS_BI","schemaName":"WKSP_ELWAGHA50","sxml":""}