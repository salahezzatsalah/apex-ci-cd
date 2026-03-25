-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463930515 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\app_menu_home.sql
-- sqlcl_snapshot src/database/dev_schema/tables/app_menu_home.sql:null:649dfa2515e7826f11bb51e8476a0432751a908a:create

create table app_menu_home (
    menu_id         number generated always as identity not null enable,
    menu_label      varchar2(200 byte),
    menu_icon       varchar2(50 byte),
    menu_url        varchar2(500 byte),
    menu_image_url  varchar2(500 byte),
    menu_image_blob blob,
    mime_type       varchar2(100 byte),
    file_name       varchar2(255 byte),
    parent_menu_id  number,
    display_order   number default 0,
    is_active       char(1 byte) default 'Y',
    created         timestamp(6) default systimestamp,
    created_by      varchar2(100 byte),
    updated         timestamp(6),
    updated_by      varchar2(100 byte),
    menu_page_id    number
);

alter table app_menu_home add primary key ( menu_id )
    using index enable;

