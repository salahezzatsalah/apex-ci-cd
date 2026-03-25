-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463973910 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\invoice_payments.sql
-- sqlcl_snapshot src/database/dev_schema/tables/invoice_payments.sql:null:a9d08cf57110af806d5f8a003e708173b0032628:create

create table invoice_payments (
    payment_id             varchar2(30 byte),
    invoice_id             varchar2(30 byte),
    payment_method         varchar2(20 byte),
    payment_status         varchar2(20 byte) default 'POSTED',
    currency_code          varchar2(10 byte),
    amount_orig            number(12, 2),
    exchange_rate_to_inv   number(18, 6) default 1,
    amount_in_inv_currency number(12, 2),
    paid_at                timestamp(6) default systimestamp,
    received_by            varchar2(200 byte),
    notes                  varchar2(1000 byte),
    created_at             timestamp(6) default systimestamp,
    created_by             varchar2(200 byte),
    voided_at              timestamp(6),
    voided_by              varchar2(200 byte),
    void_reason            varchar2(1000 byte)
);

create unique index pk_invoice_payments on
    invoice_payments (
        payment_id
    );

alter table invoice_payments
    add constraint pk_invoice_payments primary key ( payment_id )
        using index pk_invoice_payments enable;

