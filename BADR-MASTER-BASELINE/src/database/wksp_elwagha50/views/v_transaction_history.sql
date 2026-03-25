create or replace force editionable view v_transaction_history (
    account_id,
    entry_id,
    account_name,
    transaction_date,
    description,
    reference_number,
    currency_code,
    signed_amount,
    balance_after_transaction,
    created_by,
    created,
    created_by_name
) as
    select
        e.account_id,
        e.entry_id,
        a.account_name,
        t.transaction_date,
        t.description,
        t.reference_number,
        e.currency_code,
    -- Signed amount
        case
            when e.transaction_type = 'DEBIT'  then
                - 1 * nvl(e.debit_amount, 0)
            when e.transaction_type = 'CREDIT' then
                nvl(e.credit_amount, 0)
            else
                0
        end              as signed_amount,
    -- Running balance
        sum(
            case
                when e.transaction_type = 'DEBIT'  then
                    - 1 * nvl(e.debit_amount, 0)
                when e.transaction_type = 'CREDIT' then
                    nvl(e.credit_amount, 0)
                else
                    0
            end
        )
        over(partition by e.account_id
             order by
                 e.created,
                 e.entry_id
            rows between unbounded preceding and current row
        )                as balance_after_transaction,
        e.created_by,
        e.created,
        ucn.creator_name as created_by_name
    from
             transaction_entries e
        join transactions          t on e.transaction_id = t.transaction_id
        join accounts              a on e.account_id = a.account_id
        left join unified_creator_names ucn on e.created_by = ucn.creator_id
    where
        t.status = 'POSTED';


-- sqlcl_snapshot {"hash":"a41e8d4627b759a39d2126cb477c81de9e52477c","type":"VIEW","name":"V_TRANSACTION_HISTORY","schemaName":"WKSP_ELWAGHA50","sxml":""}