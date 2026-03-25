create or replace force editionable view vw_trip_transactions_log (
    driver_id,
    driver_name,
    driver_phone,
    account_name,
    account_code,
    currency_code,
    owner_type,
    product_id,
    assignment_id,
    transaction_id,
    reference_number,
    description,
    transaction_date,
    status,
    created_by,
    created,
    transaction_type,
    debit_amount,
    credit_amount,
    notes,
    trip_id
) as
    select
        acc.owner_id as driver_id,
        cd.driver_name,
        cd.phone     as driver_phone,
        acc.account_name,
        acc.account_code,
        acc.currency_code,
        acc.owner_type,
        a.product_id,
        a.assignment_id,
        t.transaction_id,
        t.reference_number,
        t.description,
        t.transaction_date,
        t.status,
        t.created_by,
        t.created,
        te.transaction_type,
        te.debit_amount,
        te.credit_amount,
        te.notes,

    -- Infer TRIP_ID from reference pattern
        case
            when t.reference_number like 'TRIP_DRIVER_SHARE_%' then
                substr(t.reference_number,
                       length('TRIP_DRIVER_SHARE_') + 1)
            when t.reference_number like 'EXP-%' then
                (
                    select
                        trip_id
                    from
                        limo_trip_expenses
                    where
                        expense_id = t.reference_number
                    fetch first rows only
                )
            when t.reference_number like 'COLL-%' then
                (
                    select
                        trip_id
                    from
                        limo_trip_collections
                    where
                        collection_id = t.reference_number
                    fetch first rows only
                )
            else
                null
        end          as trip_id
    from
             transactions t
        join transaction_entries      te on te.transaction_id = t.transaction_id
        join accounts                 acc on acc.account_id = te.account_id
        left join company_drivers          cd on acc.owner_type = 'Driver'
                                        and cd.driver_id = acc.owner_id
        join limo_product_assignments a on a.driver_id = acc.owner_id
                                           and acc.owner_type = 'Driver'
    where
        acc.owner_type = 'Driver';


-- sqlcl_snapshot {"hash":"3ec95a6a1422f2cebb384935a14b87c00ffea118","type":"VIEW","name":"VW_TRIP_TRANSACTIONS_LOG","schemaName":"WKSP_ELWAGHA50","sxml":""}