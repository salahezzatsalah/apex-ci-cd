-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464023529 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\promo_codes.sql
-- sqlcl_snapshot src/database/dev_schema/tables/promo_codes.sql:null:2d5b3c0df9e37b85d3f9fe4a121488f0793d0950:create

create table promo_codes (
    promo_id             varchar2(30 byte),
    promo_code           varchar2(50 byte),
    promo_name           varchar2(200 byte),
    description          varchar2(1000 byte),
    discount_type        varchar2(20 byte),
    discount_value       number(12, 2),
    min_invoice_amount   number(12, 2),
    max_discount_amount  number(12, 2),
    currency_code        varchar2(10 byte),
    is_active            varchar2(1 byte) default 'Y',
    start_date           date,
    end_date             date,
    usage_limit_total    number,
    usage_limit_customer number,
    created_at           date default sysdate,
    created_by           varchar2(200 byte),
    updated_at           date,
    updated_by           varchar2(200 byte)
);

alter table promo_codes add primary key ( promo_id )
    using index enable;

alter table promo_codes add unique ( promo_code )
    using index enable;

