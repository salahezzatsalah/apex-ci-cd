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


-- sqlcl_snapshot {"hash":"04077fad77475f50b47c80ba2274cb729cbb349c","type":"TRIGGER","name":"TRG_ENTRIES_BASE_AMOUNT","schemaName":"DEV_SCHEMA","sxml":""}