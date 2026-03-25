-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463975403 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\invoices.sql
-- sqlcl_snapshot src/database/dev_schema/tables/invoices.sql:null:9380c04b98b3943bd2058574cb8c1f1c9b3e5358:create

create table invoices (
    invoice_id     varchar2(30 byte),
    invoice_no     varchar2(50 byte),
    invoice_date   date,
    due_date       date,
    currency_code  varchar2(10 byte),
    total_amount   number(12, 2),
    tax_amount     number(12, 2),
    grand_total    number(12, 2),
    status         varchar2(20 byte),
    pdf_url        varchar2(1000 byte),
    created_at     date default sysdate,
    created_by     varchar2(200 byte),
    vat_included   varchar2(1 byte) default 'Y',
    vat_rate       number(6, 4),
    pdf_blob       blob,
    updated_at     date,
    updated_by     varchar2(200 byte),
    paid_amount    number(12, 2) default 0,
    balance_amount number(12, 2) default 0,
    main_res_id    varchar2(30 byte)
);

alter table invoices add primary key ( invoice_id )
    using index enable;

