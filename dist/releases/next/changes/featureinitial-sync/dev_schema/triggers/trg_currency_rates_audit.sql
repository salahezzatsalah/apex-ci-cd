-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464086565 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_currency_rates_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_currency_rates_audit.sql:null:dca3a5132133dd956597831ad9dcb0be600ad35e:create

create or replace editionable trigger trg_currency_rates_audit before
    insert or update on currency_rates
    for each row
begin
  -- Use Egypt timezone
    declare
        v_egypt_time timestamp := systimestamp;
    begin
    -- Set created metadata on insert
        if inserting then
            :new.created := nvl(:new.created,
                                v_egypt_time);
            :new.created_by := nvl(:new.created_by,
                                   nvl(
                                               apex_util.get_session_state('APP_USER_ID'),
                                               user
                                           ));

        end if;

    -- Always update modified metadata
        if updating then
            :new.updated := v_egypt_time;
            :new.updated_by := nvl(
                apex_util.get_session_state('APP_USER_ID'),
                user
            );
        end if;

    end;
end;
/

alter trigger trg_currency_rates_audit enable;

