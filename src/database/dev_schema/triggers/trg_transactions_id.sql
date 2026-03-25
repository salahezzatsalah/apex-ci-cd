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


-- sqlcl_snapshot {"hash":"6036398ecd4db10ae6c29ba52781b91d2c5d3a6f","type":"TRIGGER","name":"TRG_TRANSACTIONS_ID","schemaName":"DEV_SCHEMA","sxml":""}