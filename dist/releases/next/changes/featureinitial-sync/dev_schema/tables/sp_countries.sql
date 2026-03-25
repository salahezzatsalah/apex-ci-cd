-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464031620 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\sp_countries.sql
-- sqlcl_snapshot src/database/dev_schema/tables/sp_countries.sql:null:d97573dad1b4f61e0f288bb121d5b611753fe328:create

create table sp_countries (
    id              number default on null to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    country_code    varchar2(2 char),
    country_code3   varchar2(3 char),
    country_name    varchar2(255 char),
    region          varchar2(30 char),
    display_yn      varchar2(1 char),
    quick_pick_yn   varchar2(1 char),
    lat             number,
    lon             number,
    created         date,
    created_by      varchar2(255 char),
    updated         date,
    updated_by      varchar2(255 char),
    country_name_ar varchar2(100 byte)
);

create unique index sp_countries_pk on
    sp_countries (
        id
    );

alter table sp_countries
    add constraint sp_countries_pk primary key ( id )
        using index sp_countries_pk enable;

