-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463948574 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\drive_items.sql
-- sqlcl_snapshot src/database/dev_schema/tables/drive_items.sql:null:efb3fb70f2f631e86b1f9ebd5a10a7133f088eee:create

create table drive_items (
    item_id      varchar2(300 byte),
    parent_id    varchar2(300 byte),
    item_name    varchar2(255 byte),
    item_type    varchar2(10 byte) default 'FOLDER',
    object_name  varchar2(1000 byte),
    created_by   varchar2(100 byte),
    created_at   timestamp(6) default systimestamp,
    updated_by   varchar2(100 byte),
    updated_at   timestamp(6),
    is_deleted   char(1 byte) default 'N',
    deleted_by   varchar2(100 byte),
    deleted_at   timestamp(6),
    content_type varchar2(255 byte)
);

alter table drive_items add primary key ( item_id )
    using index enable;

