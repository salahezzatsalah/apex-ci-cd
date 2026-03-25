create or replace editionable trigger hash_password_driver before
    insert or update of password_hash on company_drivers
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

alter trigger hash_password_driver enable;


-- sqlcl_snapshot {"hash":"2a251e087dacb7cb87eeb19a2592f645c2372e99","type":"TRIGGER","name":"HASH_PASSWORD_DRIVER","schemaName":"WKSP_ELWAGHA50","sxml":""}