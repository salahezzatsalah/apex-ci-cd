-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464041948 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\trip_cancelled_days.sql
-- sqlcl_snapshot src/database/dev_schema/tables/trip_cancelled_days.sql:null:2c45fa52aa6aa02a160c01db34e98821fc557eb5:create

create table trip_cancelled_days (
    id             varchar2(30 byte) default 'CANCEL-' || to_char(sysdate, 'YYYYMMDDHH24MISS'),
    product_id     varchar2(30 byte),
    cancelled_date date,
    created        timestamp(6) default systimestamp,
    created_by     varchar2(100 byte)
);

alter table trip_cancelled_days add primary key ( id )
    using index enable;

