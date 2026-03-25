create or replace editionable trigger trg_company_drivers_id before
    insert on company_drivers
    for each row
    when ( new.driver_id is null )
declare
    v_next number;
begin
    select
        seq_company_driver_id.nextval
    into v_next
    from
        dual;

    :new.driver_id := 'DRV-'
                      || lpad(v_next, 3, '0');
end;
/

alter trigger trg_company_drivers_id enable;


-- sqlcl_snapshot {"hash":"3fb56b1378c8a9ecb2b964d75f5f21b5dd98e6a7","type":"TRIGGER","name":"TRG_COMPANY_DRIVERS_ID","schemaName":"DEV_SCHEMA","sxml":""}