-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464018278 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\payments.sql
-- sqlcl_snapshot src/database/dev_schema/tables/payments.sql:null:741119b9078f3971998cf57a448fed4ec2805e01:create

create table payments (
    payment_id          varchar2(30 byte),
    reservation_id      varchar2(30 byte),
    service_type        varchar2(20 byte),
    payment_amount      number(12, 2),
    payment_currency    varchar2(10 byte) default 'EGP',
    exchange_rate       number(10, 4) default 1,
    amount_in_egp       number(12, 2) generated always as ( payment_amount * exchange_rate ) virtual,
    payment_method      varchar2(30 byte),
    reference_number    varchar2(100 byte),
    paid_by_client_id   varchar2(30 byte),
    received_by_emp_id  varchar2(30 byte),
    company_accountno   varchar2(30 byte),
    notes               varchar2(1000 byte),
    attachment_filename varchar2(300 byte),
    attachment_mimetype varchar2(100 byte),
    attachment_blob     blob,
    created_by          varchar2(100 byte),
    updated_by          varchar2(100 byte),
    toaccount_yn        char(1 byte) default 'N',
    attachment_yn       char(1 byte) default 'N',
    created             timestamp(6) with time zone,
    updated             timestamp(6) with time zone,
    payment_date        timestamp(6) with time zone
);

alter table payments add primary key ( payment_id )
    using index enable;

