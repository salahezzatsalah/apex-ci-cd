-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463952169 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fast_track_assignments.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fast_track_assignments.sql:null:0253ef551f9a07e2153a0661213e83c0baab1ae6:create

create table fast_track_assignments (
    assignment_id                varchar2(30 byte),
    reservation_id               varchar2(30 byte),
    vendor_id                    varchar2(50 byte),
    assignment_type              varchar2(20 byte),
    created_by                   varchar2(30 byte),
    updated_by                   varchar2(30 byte),
    vendor_status                varchar2(20 byte) default 'CURRENT',
    vendor_share_type            varchar2(10 byte),
    vendor_share_value           number(10, 2),
    currency                     varchar2(10 byte) default 'EGP',
    exchange_rate                number(10, 4) default 1,
    created                      timestamp(6) with time zone default current_timestamp,
    updated                      timestamp(6) with time zone,
    notes                        varchar2(300 byte),
    total_service_amount         number(12, 2),
    total_service_amount_egp     number(12, 2),
    vendor_total_payout_egp      number(12, 2),
    office_net_egp               number(12, 2),
    total_expenses_egp           number(12, 2),
    total_added_services_egp     number(12, 2),
    total_collected_egp          number(12, 2),
    collections_by_currency_json clob,
    accounting_updated_at        timestamp(6) with time zone
);

alter table fast_track_assignments add primary key ( assignment_id )
    using index enable;

