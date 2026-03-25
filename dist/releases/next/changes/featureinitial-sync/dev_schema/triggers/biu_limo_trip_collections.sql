-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464056235 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\biu_limo_trip_collections.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/biu_limo_trip_collections.sql:null:5dfadb4920289af48def728514da691a311a3f33:create

create or replace editionable trigger biu_limo_trip_collections before
    insert on limo_trip_collections
    for each row
declare
    v_rate number;
begin
    if :new.collection_id is null then
        :new.collection_id := 'COLLECT-'
                              || lpad(seq_limo_trip_collections.nextval, 6, '0');
    end if;

    if :new.created is null then
        :new.created := systimestamp;
    end if;

    if :new.created_by is null then
        :new.created_by := nvl(
            v('APP_USER_ID'),
            user
        );
    end if;

  -- Default exchange rate from the trip if not provided
    if :new.exchange_rate_used is null then
        select
            nvl(t.exchange_rate, 1)
        into v_rate
        from
            limo_trips_tracker_v2 t
        where
            t.trip_id = :new.trip_id;

        :new.exchange_rate_used := nvl(v_rate, 1);
    end if;

end;
/

alter trigger biu_limo_trip_collections enable;

