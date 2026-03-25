-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464119375 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_transactions_id.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_transactions_id.sql:null:fcf3eedda6c59b8af80830d58bc5964e90812879:create

create or replace editionable trigger trg_transactions_id before
    insert on transactions
    for each row
begin
    if :new.transaction_id is null then
        :new.transaction_id := transactions_seq.nextval;
    end if;
end;
/

alter trigger trg_transactions_id enable;

