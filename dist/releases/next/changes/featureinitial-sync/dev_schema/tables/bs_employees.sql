-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463933631 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\bs_employees.sql
-- sqlcl_snapshot src/database/dev_schema/tables/bs_employees.sql:null:28306d73bf34a33bae8fcf09ca72fc614fb462a6:create

create table bs_employees (
    username           varchar2(100 char),
    password_hash      varchar2(500 char),
    first_name         varchar2(255 char),
    last_name          varchar2(255 char),
    initials           varchar2(3 char),
    screen_name        varchar2(50 char),
    email              varchar2(255 char),
    email_domain       varchar2(255 char),
    notification_pref  varchar2(255 char),
    comment_notif_pref varchar2(255 char),
    tags               varchar2(4000 char),
    hash_tag_reference varchar2(30 char),
    photo              blob,
    photo_filename     varchar2(512 char),
    photo_mimetype     varchar2(512 char),
    photo_charset      varchar2(512 char),
    is_current_yn      varchar2(1 char) default 'Y',
    account_locked_yn  varchar2(1 char) default 'N',
    location           varchar2(500 char),
    department_id      number,
    job_title          varchar2(255 char),
    competencies       varchar2(4000 char),
    created_by         varchar2(255 char),
    updated_by         varchar2(255 char),
    full_time_yn       varchar2(1 char) default 'Y',
    dept_leader_yn     varchar2(1 char) default 'N',
    status             varchar2(20 char) default 'Active',
    employee_type      varchar2(50 char),
    is_available_yn    varchar2(1 char) default 'Y',
    national_id        varchar2(50 char),
    city               varchar2(100 char),
    country_id         number,
    phone_number       varchar2(50 char),
    id                 varchar2(300 byte),
    photo_lastupd      timestamp(6) with time zone,
    created            timestamp(6) with time zone,
    updated            timestamp(6) with time zone,
    join_date          timestamp(6) with time zone,
    leave_date         timestamp(6) with time zone,
    photo_url          varchar2(4000 byte)
);

create unique index bs_employees_pk on
    bs_employees (
        id
    );

alter table bs_employees add constraint bs_employees_email_uk unique ( email ) disable;

alter table bs_employees add constraint bs_employees_hash_tag_uk unique ( hash_tag_reference ) disable;

alter table bs_employees
    add constraint bs_employees_pk primary key ( id )
        using index bs_employees_pk enable;

alter table bs_employees add constraint bs_employees_username_uk unique ( username ) disable;

