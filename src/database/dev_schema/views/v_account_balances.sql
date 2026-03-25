create or replace force editionable view v_account_balances (
    account_id,
    account_code,
    account_name,
    currency_code,
    base_balance,
    balance
) as
    select
        a.account_id,
        a.account_code,
        a.account_name,
        a.currency_code,
        nvl(
            sum(
                case
                    when e.debit_amount is not null then
                        - 1 * e.base_amount
                    when e.credit_amount is not null then
                        e.base_amount
                    else
                        0
                end
            ),
            0
        ) as base_balance,
        nvl(
            sum(
                case
                    when e.debit_amount is not null then
                        - 1 * e.debit_amount
                    when e.credit_amount is not null then
                        e.credit_amount
                    else
                        0
                end
            ),
            0
        ) as balance
    from
        accounts            a
        left join transaction_entries e on a.account_id = e.account_id
        left join transactions        t on e.transaction_id = t.transaction_id
    where
        t.status = 'POSTED'
    group by
        a.account_id,
        a.account_code,
        a.account_name,
        a.currency_code;


-- sqlcl_snapshot {"hash":"c4b25d7512c6ee0a17d2f94c9c7d89ceb9e3dd45","type":"VIEW","name":"V_ACCOUNT_BALANCES","schemaName":"DEV_SCHEMA","sxml":""}