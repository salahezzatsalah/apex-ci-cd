-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464038420 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\suppliers.sql
-- sqlcl_snapshot src/database/dev_schema/tables/suppliers.sql:null:31f16928bc6190f3e88e5885bd625b83aeffde0b:create

create table suppliers (
    supplier_name      varchar2(255 byte),
    is_company         varchar2(1 byte) default 'N',
    supplier_type_id   number,
    national_id        varchar2(50 byte),
    tax_id             varchar2(50 byte),
    phone              varchar2(50 byte),
    email              varchar2(255 byte),
    address            varchar2(500 byte),
    city               varchar2(100 byte),
    country_id         number,
    notes              varchar2(1000 byte),
    profile_photo      blob,
    photo_filename     varchar2(255 byte),
    photo_mimetype     varchar2(255 byte),
    photo_charset      varchar2(100 byte),
    created_by         varchar2(100 byte),
    updated_by         varchar2(100 byte),
    company_reg_no     varchar2(100 byte),
    contact_person     varchar2(255 byte),
    has_portal_access  varchar2(1 byte) default 'N',
    username           varchar2(100 byte),
    password_hash      varchar2(500 byte),
    status             varchar2(10 byte) default 'ACTIVE',
    photo_last_updated timestamp(6) with time zone,
    created            timestamp(6) with time zone,
    updated            timestamp(6) with time zone,
    old_supplier_id    number,
    supplier_id        varchar2(50 byte),
    photo_url          varchar2(2000 byte)
);

create unique index pk_suppliers on
    suppliers (
        supplier_id
    );

alter table suppliers
    add constraint pk_suppliers primary key ( supplier_id )
        using index pk_suppliers enable;

