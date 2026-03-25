create or replace editionable trigger trg_expense_insert_sync_txn after
    insert on limo_trip_expenses
    for each row
declare
    v_driver_id varchar2(50);
begin
    -- You must resolve DRIVER_ID from ASSIGNMENT_ID or TRIP_ID as your logic allows
    select
        driver_id
    into v_driver_id
    from
        limo_product_assignments
    where
        assignment_id = :new.assignment_id;

    sync_driver_expense_transaction(
        p_expense_id    => :new.expense_id,
        p_trip_id       => :new.trip_id,
        p_assignment_id => :new.assignment_id,
        p_expense_date  => :new.expense_date,
        p_expense_type  => :new.expense_type,
        p_amount        => :new.amount,
        p_currency      => :new.currency,
        p_details       => :new.details,
        p_status        => :new.status,
        p_driver_id     => v_driver_id,
        p_created_by    => :new.created_by
    );

end;
/

alter trigger trg_expense_insert_sync_txn enable;


-- sqlcl_snapshot {"hash":"c57d08442c1ccd48c15a3ddc29b4cef865c566a4","type":"TRIGGER","name":"TRG_EXPENSE_INSERT_SYNC_TXN","schemaName":"WKSP_ELWAGHA50","sxml":""}