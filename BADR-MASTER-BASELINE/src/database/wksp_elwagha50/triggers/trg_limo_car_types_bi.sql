create or replace editionable trigger trg_limo_car_types_bi before
    insert on limo_car_types
    for each row
begin
    if :new.car_type_id is null then
        :new.car_type_id := 'CAR-'
                            || lpad(limo_car_type_seq.nextval, 5, '0');
    end if;

    :new.created := systimestamp;
    :new.created_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );

  -- initialize UPDATED fields on insert as well
    :new.updated := :new.created;
    :new.updated_by := :new.created_by;
end;
/

alter trigger trg_limo_car_types_bi enable;


-- sqlcl_snapshot {"hash":"588f0343d6b6a971f8b608d48a453c36dad05cd5","type":"TRIGGER","name":"TRG_LIMO_CAR_TYPES_BI","schemaName":"WKSP_ELWAGHA50","sxml":""}