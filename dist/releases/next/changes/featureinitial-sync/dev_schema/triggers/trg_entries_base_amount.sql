-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464090824 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_entries_base_amount.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_entries_base_amount.sql:null:864e1a07c9808f26f504244c574a8bf6871835c7:create

create or replace editionable trigger trg_entries_base_amount before
    insert on transaction_entries
    for each row
declare
    v_default_currency varchar2(10);
begin
    -- Determine default currency
    select
        currency_code
    into v_default_currency
    from
        default_currency
    where
        id = 1;

    -- Determine exchange rate and base amount
    if :new.currency_code = v_default_currency then
        :new.exchange_rate := 1;
        :new.base_amount := nvl(:new.debit_amount,
                                :new.credit_amount);

    else
        select
            exchange_rate
        into :new.exchange_rate
        from
            (
                select
                    exchange_rate
                from
                    currency_rates
                where
                    currency_code = :new.currency_code
                order by
                    rate_date desc
                fetch first 1 rows only
            );

        :new.base_amount := nvl(:new.debit_amount,
                                :new.credit_amount) * :new.exchange_rate;

    end if;

    -- Automatically set transaction type
    if :new.debit_amount is not null then
        :new.transaction_type := 'DEBIT';
    elsif :new.credit_amount is not null then
        :new.transaction_type := 'CREDIT';
    else
        :new.transaction_type := null;
    end if;

end;
/

alter trigger trg_entries_base_amount enable;

