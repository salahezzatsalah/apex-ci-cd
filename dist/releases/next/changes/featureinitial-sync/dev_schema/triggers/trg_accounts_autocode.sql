-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464081155 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_accounts_autocode.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_accounts_autocode.sql:null:90174ca3de75db2c95e009cdb8104689598d65e1:create

create or replace editionable trigger trg_accounts_autocode before
    insert on accounts
    for each row
begin
  -- Only generate ACCOUNT_CODE if it was left null
    if :new.account_code is null then
        :new.account_code := 'ACC-'
                             || lpad(:new.account_id,
                                     6,
                                     '0');

    end if;
end;
/

alter trigger trg_accounts_autocode enable;

