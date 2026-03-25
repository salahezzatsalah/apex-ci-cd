-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464069961 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\hash_password_driver.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/hash_password_driver.sql:null:84336926b8e29043af1c6b028581cfb62b5e3e2f:create

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

