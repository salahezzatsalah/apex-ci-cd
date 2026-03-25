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


-- sqlcl_snapshot {"hash":"8d1904a640f6e227594de6555d971f078d5e1d37","type":"TRIGGER","name":"TRG_UPDATE_TRIP_PRICE_V2","schemaName":"WKSP_ELWAGHA50","sxml":""}