-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464064189 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\company_registered_cars_biu.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/company_registered_cars_biu.sql:null:ca5127abff31de7a23e2cc26f50e386e62ef5354:create

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

