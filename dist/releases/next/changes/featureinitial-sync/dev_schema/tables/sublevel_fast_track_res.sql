-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464034863 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\sublevel_fast_track_res.sql
-- sqlcl_snapshot src/database/dev_schema/tables/sublevel_fast_track_res.sql:null:f69174d02d38c4a21cd0d5efafef837ac0e3e95f:create

create table sublevel_fast_track_res (
    sub_res_id       varchar2(30 byte),
    order_item_id    varchar2(30 byte),
    cat_item_id      varchar2(50 byte),
    res_date         date,
    res_time         varchar2(5 byte),
    airport_id       varchar2(100 byte),
    terminal_no      varchar2(20 byte),
    ticket_url       varchar2(4000 byte),
    passengers_no    number(4, 0),
    passengers_info  json,
    currency         varchar2(10 byte),
    exchange_rate    number(18, 10),
    price_per_person number(10, 2) default 0,
    total_amount     number(12, 2),
    status           varchar2(50 byte) default 'PENDING',
    signage_details  varchar2(300 byte),
    notes            varchar2(1000 byte),
    created          timestamp(6) default systimestamp,
    created_by       varchar2(200 byte),
    updated          timestamp(6),
    updated_by       varchar2(200 byte),
    is_deleted       char(1 byte) default 'N',
    deleted          timestamp(6),
    deleted_by       varchar2(200 byte),
    service_class    varchar2(50 byte),
    main_res_id      varchar2(50 byte),
    status_code      varchar2(40 byte) default 'PENDING_ASSIGNMENT'
);

alter table sublevel_fast_track_res add primary key ( sub_res_id )
    using index enable;

