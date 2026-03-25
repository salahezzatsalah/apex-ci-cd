-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464095667 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_ft_service_prices_audit.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_ft_service_prices_audit.sql:null:c2fb5371c9058ebbbdfcd00dd31f8bb2d5708ce8:create

create or replace editionable trigger trg_ft_service_prices_audit before
    insert or update on fast_track_service_prices
    for each row
begin
    if inserting then
        if :new.created is null then
            :new.created := current_timestamp;
        end if;

        if :new.created_by is null then
            :new.created_by := nvl(
                apex_util.get_session_state('APP_USER_FULLNAME'),  -- preferred: full name
                nvl(
                                apex_util.get_session_state('APP_USER_ID'),   -- fallback: app user id
                                user
                            )                                        -- fallback: db user
            );

        end if;

    end if;

    :new.updated := current_timestamp;
    :new.updated_by := nvl(
        apex_util.get_session_state('APP_USER_FULLNAME'),
        nvl(
                apex_util.get_session_state('APP_USER_ID'),
                user
            )
    );

end;
/

alter trigger trg_ft_service_prices_audit enable;

