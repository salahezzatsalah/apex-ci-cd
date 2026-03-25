-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463949368 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\driver_app_menu.sql
-- sqlcl_snapshot src/database/dev_schema/tables/driver_app_menu.sql:null:230de987453153c5f1ce78c363b909c7619b6acf:create

create table driver_app_menu (
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

alter table driver_app_menu add primary key ( menu_id )
    using index enable;

