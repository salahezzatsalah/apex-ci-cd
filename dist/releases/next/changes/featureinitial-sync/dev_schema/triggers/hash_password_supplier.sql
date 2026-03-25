-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464070744 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\hash_password_supplier.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/hash_password_supplier.sql:null:4400dc99a5dd3cf09bcb2f60e0f616f057fc3109:create

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

