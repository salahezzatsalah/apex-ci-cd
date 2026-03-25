-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463976723 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_add_services.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_add_services.sql:null:ffc071e505c9f0bcc90fc2b61dccdc646396bceb:create

create table limo_add_services (
    add_service_id    varchar2(50 byte),
    trip_id           varchar2(50 byte),
    assignment_id     varchar2(50 byte),
    service_type_code varchar2(50 byte),
    currency          varchar2(10 byte) default 'EGP',
    exchange_rate     number(10, 4) default 1,
    amount            number(10, 2),
    quantity          number(10, 2),
    unit_type         varchar2(20 byte) default 'UNIT',
    rate_per_unit     number(10, 2),
    amount_egp        number(10, 2) generated always as ( nvl(amount,
                                                       nvl(quantity, 1) * nvl(rate_per_unit, 0)) * nvl(exchange_rate, 1) ) virtual,
    service_details   varchar2(255 byte),
    created_by        varchar2(50 byte),
    updated_by        varchar2(50 byte),
    created           timestamp(6) with time zone,
    updated           timestamp(6) with time zone,
    service_date      timestamp(6) with time zone
);

alter table limo_add_services add primary key ( add_service_id )
    using index enable;

