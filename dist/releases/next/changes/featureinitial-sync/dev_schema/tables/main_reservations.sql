-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464009049 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\main_reservations.sql
-- sqlcl_snapshot src/database/dev_schema/tables/main_reservations.sql:null:9631a68faf29287da0b4a92cb55fee6d3c74991e:create

create table main_reservations (
    main_res_id        varchar2(30 byte),
    customer_id        varchar2(50 byte),
    currency_code      varchar2(10 byte),
    total_amount       number(12, 2),
    notes              varchar2(1000 byte),
    created            timestamp(6) default systimestamp,
    created_by         varchar2(200 byte),
    updated            timestamp(6),
    updated_by         varchar2(200 byte),
    status             varchar2(20 byte) default 'ACTIVE',
    opened_at          timestamp(6) default systimestamp,
    closed_at          timestamp(6),
    closed_by          varchar2(200 byte),
    billing_group_id   varchar2(30 byte),
    payment_status     varchar2(30 byte) default 'CART',
    payment_provider   varchar2(30 byte),
    payment_ref        varchar2(200 byte),
    checked_out_at     timestamp(6),
    paid_at            timestamp(6),
    payment_updated_at timestamp(6),
    payment_updated_by varchar2(200 byte)
);

alter table main_reservations add primary key ( main_res_id )
    using index enable;

