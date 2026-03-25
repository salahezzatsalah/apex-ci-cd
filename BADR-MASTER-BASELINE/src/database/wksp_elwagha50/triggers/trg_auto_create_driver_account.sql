create or replace editionable trigger trg_auto_create_driver_account after
    insert on company_drivers
    for each row
begin
    create_driver_egp_account(:new.driver_id,
                              :new.driver_name);
end;
/

alter trigger trg_auto_create_driver_account enable;


-- sqlcl_snapshot {"hash":"862738bbcd86c5d4b362f5808e503a705977be0a","type":"TRIGGER","name":"TRG_AUTO_CREATE_DRIVER_ACCOUNT","schemaName":"WKSP_ELWAGHA50","sxml":""}