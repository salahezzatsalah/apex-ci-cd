-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463958850 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fast_track_settlements.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fast_track_settlements.sql:null:a473db91415f42a05e78ca18feeac4e7a98add12:create

create table fast_track_settlements (
    settlement_id    varchar2(30 byte),
    period_start     date,
    period_end       date,
    source_office_id varchar2(30 byte),
    dest_office_id   varchar2(30 byte),
    total_requests   number,
    total_amount     number(12, 2),
    total_commission number(12, 2),
    status           varchar2(20 byte) default 'PENDING',
    created          timestamp(6) default current_timestamp,
    created_by       varchar2(30 byte),
    notes            varchar2(1000 byte)
);

alter table fast_track_settlements add primary key ( settlement_id )
    using index enable;

