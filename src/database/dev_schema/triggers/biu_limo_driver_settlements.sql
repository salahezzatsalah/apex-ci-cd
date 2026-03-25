create or replace editionable trigger biu_limo_driver_settlements before
    insert on limo_driver_settlements
    for each row
begin
    if :new.id is null then
        select
            'SETTLE-'
            || lpad(seq_limo_settlements.nextval, 6, '0')
        into :new.id
        from
            dual;

    end if;
end;
/

alter trigger biu_limo_driver_settlements enable;


-- sqlcl_snapshot {"hash":"5c0f3ed3992bd61d20180e54837d6cc916033298","type":"TRIGGER","name":"BIU_LIMO_DRIVER_SETTLEMENTS","schemaName":"DEV_SCHEMA","sxml":""}