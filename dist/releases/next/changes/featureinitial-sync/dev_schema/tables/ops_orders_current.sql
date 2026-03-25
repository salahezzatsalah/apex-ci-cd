-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464010693 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\ops_orders_current.sql
-- sqlcl_snapshot src/database/dev_schema/tables/ops_orders_current.sql:null:9f60a6ac5cec6176def317fca0f9858fe9800ac3:create

create table ops_orders_current (
    order_item_id       varchar2(50 byte),
    main_res_id         varchar2(50 byte),
    customer_id         varchar2(50 byte),
    client_code         varchar2(50 byte),
    client_phone        varchar2(50 byte),
    item_type           varchar2(50 byte),
    ref_table           varchar2(50 byte),
    ref_id              varchar2(50 byte),
    service_title_ar    varchar2(500 byte),
    service_subtitle_ar varchar2(1000 byte),
    service_photo_url   varchar2(4000 byte),
    status_code         varchar2(30 byte),
    raw_status          varchar2(50 byte),
    assigned_to_id      varchar2(50 byte),
    assigned_to_name    varchar2(200 byte),
    last_status_at      date,
    last_status_by      varchar2(100 byte),
    created_at          date,
    service_start_ts    timestamp(6),
    service_end_ts      timestamp(6),
    hours_to_service    number(10, 2),
    age_hours           number(10, 2),
    amount_orig         number(12, 2),
    currency            varchar2(10 byte),
    amount_egp          number(12, 2),
    priority_score      number(6, 0),
    time_weight         number(4, 0),
    risk_weight         number(4, 0),
    owner_team          varchar2(50 byte),
    region_code         varchar2(30 byte),
    source_system       varchar2(50 byte) default 'ORDER_ITEMS',
    last_sync_at        date default sysdate,
    is_active           char(1 byte) default 'Y',
    created_by          varchar2(100 byte),
    updated_at          date,
    updated_by          varchar2(100 byte)
);

alter table ops_orders_current add primary key ( order_item_id )
    using index enable;

