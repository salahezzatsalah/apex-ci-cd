create or replace editionable trigger trg_limo_car_types_bu before
    update on limo_car_types
    for each row
begin
    :new.updated := systimestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger trg_limo_car_types_bu enable;


-- sqlcl_snapshot {"hash":"59561e9190595106ca8be3d1b45ab4b342be006a","type":"TRIGGER","name":"TRG_LIMO_CAR_TYPES_BU","schemaName":"WKSP_ELWAGHA50","sxml":""}