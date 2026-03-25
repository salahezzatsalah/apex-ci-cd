-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464120192 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\trg_update_trip_price_v2.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/trg_update_trip_price_v2.sql:null:406f9d885da68f8f928abaafb780ab1c3795eaf0:create

create or replace editionable trigger trg_update_trip_price_v2 for
    update of trip_price, currency, exchange_rate on limo_trip_accounting
compound trigger
    type t_trip_ids is
        table of varchar2(30);
    g_trip_ids t_trip_ids := t_trip_ids();
    after each row is begin
        g_trip_ids.extend;
        g_trip_ids(g_trip_ids.count) := :new.trip_id;
    end after each row;
    after statement is begin
        for i in 1..g_trip_ids.count loop
            recalc_trip_accounting_v2(g_trip_ids(i));
        end loop;
    end after statement;
end;
/

alter trigger trg_update_trip_price_v2 enable;

