-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464035965 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\sublevel_limo_res.sql
-- sqlcl_snapshot src/database/dev_schema/tables/sublevel_limo_res.sql:null:342aefa1520b3064174feaa648d00041da8c6113:create

create table sublevel_limo_res (
    sub_res_id          varchar2(30 byte),
    order_item_id       varchar2(30 byte),
    cat_item_id         varchar2(30 byte),
    trip_type           varchar2(20 byte),
    from_location       varchar2(400 byte),
    to_location         varchar2(400 byte),
    res_date_from       date,
    res_time            varchar2(10 byte),
    res_date_to         date,
    service_class       varchar2(50 byte),
    ticket_number       varchar2(300 byte),
    signage_details     varchar2(300 byte),
    trip_price          number(10, 2),
    currency            varchar2(10 byte) default 'EGP',
    exchange_rate       number(10, 4) default 1,
    nod                 number generated always as ( trunc(nvl(res_date_to, res_date_from)) - trunc(res_date_from) + 1 ) virtual,
    total_amount        number(22, 2) generated always as ( trip_price * ( trunc(nvl(res_date_to, res_date_from)) - trunc(res_date_from
    ) + 1 ) ) virtual,
    total_amount_egp    number(22, 2) generated always as ( trip_price * exchange_rate * ( trunc(nvl(res_date_to, res_date_from)) - trunc
    (res_date_from) + 1 ) ) virtual,
    status              varchar2(200 byte),
    notes               varchar2(1000 byte),
    created             timestamp(6) with time zone,
    created_by          varchar2(100 byte),
    updated             timestamp(6) with time zone,
    updated_by          varchar2(100 byte),
    is_deleted          char(1 byte) default 'N',
    deleted             timestamp(6) with time zone,
    deleted_by          varchar2(100 byte),
    main_res_id         varchar2(100 byte),
    status_code         varchar2(40 byte) default 'PENDING_ASSIGNMENT',
    passengers_no       number(10, 0),
    luggage_no          number(10, 0),
    request_type        varchar2(50 byte),
    parent_sub_res_id   varchar2(30 byte),
    return_type         varchar2(20 byte),
    return_status       varchar2(20 byte),
    return_confirmed_at timestamp(6) with time zone,
    ticket_url          varchar2(4000 byte),
    from_place_id       varchar2(200 byte),
    to_place_id         varchar2(200 byte),
    source              varchar2(20 byte)
);

alter table sublevel_limo_res add primary key ( sub_res_id )
    using index enable;

