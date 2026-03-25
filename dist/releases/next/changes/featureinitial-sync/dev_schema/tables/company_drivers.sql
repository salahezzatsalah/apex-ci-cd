-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463939080 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\company_drivers.sql
-- sqlcl_snapshot src/database/dev_schema/tables/company_drivers.sql:null:3417b6b66f952b6da3a1f9546ec41979bafe4b01:create

create table company_drivers (
    driver_name         varchar2(255 byte),
    national_id         varchar2(50 byte),
    license_number      varchar2(100 byte),
    license_expiry_date date,
    phone               varchar2(50 byte),
    email               varchar2(255 byte),
    address             varchar2(500 byte),
    city                varchar2(100 byte),
    country_id          number,
    status              varchar2(10 byte) default 'ACTIVE',
    employee_code       varchar2(50 byte),
    join_date           date,
    driver_level        varchar2(50 byte),
    contract_type       varchar2(50 byte),
    is_active_employee  varchar2(1 byte) default 'Y',
    department_id       number,
    profile_photo       blob,
    photo_filename      varchar2(255 byte),
    photo_mimetype      varchar2(255 byte),
    photo_charset       varchar2(100 byte),
    photo_last_updated  timestamp(6) with time zone,
    notes               varchar2(1000 byte),
    has_portal_access   varchar2(1 byte) default 'N',
    username            varchar2(100 byte),
    password_hash       varchar2(500 byte),
    created             timestamp(6) with time zone,
    created_by          varchar2(100 byte),
    updated             timestamp(6) with time zone,
    updated_by          varchar2(100 byte),
    driver_id           varchar2(50 byte),
    driver_avatar       varchar2(600 byte),
    photo_url           varchar2(2000 byte)
);

create unique index pk_company_drivers on
    company_drivers (
        driver_id
    );

alter table company_drivers
    add constraint pk_company_drivers primary key ( driver_id )
        using index pk_company_drivers enable;

