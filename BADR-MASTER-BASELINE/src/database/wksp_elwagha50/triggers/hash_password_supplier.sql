create or replace editionable trigger hash_password_supplier before
    insert or update of password_hash on suppliers
    for each row
begin
    if inserting then
        :new.password_hash := security_pkg.get_hashing(p_text => :new.password_hash);

    elsif updating then
        if :new.password_hash != :old.password_hash then
            :new.password_hash := security_pkg.get_hashing(p_text => :new.password_hash);

        end if;
    end if;
end;
/

alter trigger hash_password_supplier enable;


-- sqlcl_snapshot {"hash":"85827dbe882edc3bf92e89e8194f98dd2a1b667e","type":"TRIGGER","name":"HASH_PASSWORD_SUPPLIER","schemaName":"WKSP_ELWAGHA50","sxml":""}