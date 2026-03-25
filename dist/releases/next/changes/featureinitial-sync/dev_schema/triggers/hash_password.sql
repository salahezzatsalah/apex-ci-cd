-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464069167 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\hash_password.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/hash_password.sql:null:4241d62f10fe6d706f77444ff6e2c09d65dad67c:create

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

