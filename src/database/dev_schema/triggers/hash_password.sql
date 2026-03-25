create or replace editionable trigger hash_password before
    insert or update of password_hash on bs_employees
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

alter trigger hash_password enable;


-- sqlcl_snapshot {"hash":"2b567506ec3a1cdd8c26f0b5729aa643cfdd5e4a","type":"TRIGGER","name":"HASH_PASSWORD","schemaName":"DEV_SCHEMA","sxml":""}