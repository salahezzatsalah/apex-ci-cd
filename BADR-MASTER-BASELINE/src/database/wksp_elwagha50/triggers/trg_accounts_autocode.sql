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


-- sqlcl_snapshot {"hash":"3f4232715e71b7b67881408c9c60885c238c0fef","type":"TRIGGER","name":"TRG_ACCOUNTS_AUTOCODE","schemaName":"WKSP_ELWAGHA50","sxml":""}