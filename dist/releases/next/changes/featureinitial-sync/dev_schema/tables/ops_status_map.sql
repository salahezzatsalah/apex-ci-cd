-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464011470 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\ops_status_map.sql
-- sqlcl_snapshot src/database/dev_schema/tables/ops_status_map.sql:null:a310b28643aa26333a862c7022202f010810ab44:create

create table ops_status_map (
    ref_table   varchar2(50 byte),
    raw_status  varchar2(50 byte),
    status_code varchar2(30 byte)
);

create unique index pk_ops_status_map on
    ops_status_map (
        ref_table,
        raw_status
    );

alter table ops_status_map
    add constraint pk_ops_status_map
        primary key ( ref_table,
                      raw_status )
            using index pk_ops_status_map enable;

