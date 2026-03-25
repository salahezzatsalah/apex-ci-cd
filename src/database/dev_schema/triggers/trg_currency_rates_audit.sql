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


-- sqlcl_snapshot {"hash":"26d7c559825eea8447dc749915595c29073c8341","type":"TRIGGER","name":"TRG_CURRENCY_RATES_AUDIT","schemaName":"DEV_SCHEMA","sxml":""}