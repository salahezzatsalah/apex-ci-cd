-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464031161 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\settlement_portal_menu.sql
-- sqlcl_snapshot src/database/dev_schema/tables/settlement_portal_menu.sql:null:f35c50cb2288fe3edf73206e338a07a67a8abbba:create

create table settlement_portal_menu (
    menu_id         number,
    menu_label      varchar2(200 byte),
    menu_icon       varchar2(50 byte),
    menu_url        varchar2(500 byte),
    menu_image_url  varchar2(500 byte),
    menu_image_blob blob,
    mime_type       varchar2(100 byte),
    file_name       varchar2(255 byte),
    parent_menu_id  number,
    display_order   number,
    is_active       char(1 byte),
    created         timestamp(6),
    created_by      varchar2(100 byte),
    updated         timestamp(6),
    updated_by      varchar2(100 byte),
    menu_page_id    number
);

