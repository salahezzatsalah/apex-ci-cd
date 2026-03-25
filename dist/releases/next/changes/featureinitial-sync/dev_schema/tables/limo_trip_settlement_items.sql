-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464005657 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_trip_settlement_items.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_trip_settlement_items.sql:null:de1579b0910d5010f7ff139b3e49db48df48e1ea:create

create table limo_trip_settlement_items (
    settlement_id varchar2(50 byte),
    trip_id       varchar2(50 byte)
);

alter table limo_trip_settlement_items
    add primary key ( settlement_id,
                      trip_id )
        using index enable;

