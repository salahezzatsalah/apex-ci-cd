-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463958032 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fast_track_settlement_details.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fast_track_settlement_details.sql:null:a5cae52d796a0e0876707d0ba0eaeb8bff3289df:create

create table fast_track_settlement_details (
    detail_id         varchar2(30 byte),
    settlement_id     varchar2(30 byte),
    reservation_id    varchar2(30 byte),
    commission_amount number(12, 2),
    amount            number(12, 2),
    status            varchar2(20 byte) default 'PENDING',
    notes             varchar2(1000 byte),
    created           timestamp(6) default current_timestamp,
    created_by        varchar2(30 byte)
);

alter table fast_track_settlement_details add primary key ( detail_id )
    using index enable;

