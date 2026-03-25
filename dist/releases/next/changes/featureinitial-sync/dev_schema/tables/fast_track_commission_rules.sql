-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463953347 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fast_track_commission_rules.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fast_track_commission_rules.sql:null:3747e669263ff858e7310dc189d0d317bdcb74db:create

create table fast_track_commission_rules (
    rule_id          varchar2(30 byte),
    source_office    varchar2(30 byte),
    dest_office      varchar2(30 byte),
    commission_type  varchar2(20 byte),
    commission_value number(10, 2),
    effective_from   date,
    effective_to     date,
    status           varchar2(10 byte) default 'ACTIVE',
    notes            varchar2(500 byte),
    created          timestamp(6) default current_timestamp,
    created_by       varchar2(30 byte)
);

alter table fast_track_commission_rules add primary key ( rule_id )
    using index enable;

