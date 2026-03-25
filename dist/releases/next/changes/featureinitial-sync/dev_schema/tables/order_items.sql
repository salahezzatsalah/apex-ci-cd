-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464016159 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\order_items.sql
-- sqlcl_snapshot src/database/dev_schema/tables/order_items.sql:null:6df88039ee53c835def2a68dc83ed5274aaee153:create

create table order_items (
    order_item_id          varchar2(30 byte),
    main_res_id            varchar2(30 byte),
    item_type              varchar2(30 byte),
    ref_table              varchar2(50 byte),
    ref_id                 varchar2(30 byte),
    item_status            varchar2(30 byte),
    amount_orig            number(12, 2),
    currency               varchar2(10 byte),
    exchange_rate          number(10, 4),
    amount_egp             number(12, 2),
    created                timestamp(6) default systimestamp,
    created_by             varchar2(200 byte),
    updated                timestamp(6),
    updated_by             varchar2(200 byte),
    is_cancelled           varchar2(1 byte),
    fulfillment_status     varchar2(30 byte) default 'NEW',
    fulfillment_updated_at timestamp(6),
    fulfillment_updated_by varchar2(200 byte),
    display_title_ar       varchar2(500 byte),
    display_subtitle_ar    varchar2(1000 byte),
    service_start_ts       timestamp(6),
    service_end_ts         timestamp(6),
    assigned_to_emp_id     number,
    assigned_to_name       varchar2(255 byte),
    meta_json              clob,
    is_confirmed           char(1 byte) default 'N',
    source                 varchar2(20 byte)
);

alter table order_items add primary key ( order_item_id )
    using index enable;

