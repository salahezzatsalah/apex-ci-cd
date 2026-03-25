create or replace editionable trigger company_registered_cars_biu before
    insert or update on company_registered_cars
    for each row
begin
    if inserting then
        -- Assign ID if not provided
        if :new.id is null then
            :new.id := 'CAR-'
                       || lpad(seq_company_registered_cars.nextval, 6, '0');
        end if;
        -- Audit fields
        :new.created := current_timestamp;
        :new.created_by := nvl(
            apex_util.get_session_state('APP_USER_ID'),
            user
        );
        if :new.status is null then
            :new.status := 'ACTIVE';
        end if;

    end if;

    -- Always update these on insert or update
    :new.updated := current_timestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_ID'),
        user
    );
end;
/

alter trigger company_registered_cars_biu enable;


-- sqlcl_snapshot {"hash":"e9c811b48d58d7dafcf9636e80026c1e8f0d24f4","type":"TRIGGER","name":"COMPANY_REGISTERED_CARS_BIU","schemaName":"DEV_SCHEMA","sxml":""}