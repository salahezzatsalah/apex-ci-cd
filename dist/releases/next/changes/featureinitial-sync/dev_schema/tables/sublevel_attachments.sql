-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464032756 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\sublevel_attachments.sql
-- sqlcl_snapshot src/database/dev_schema/tables/sublevel_attachments.sql:null:1e41692f3c3760da90a611c5a361fa13d79190db:create

create table sublevel_attachments (
    attach_id   varchar2(36 byte),
    sub_res_id  varchar2(30 byte),
    filename    varchar2(512 byte),
    object_name varchar2(4000 byte),
    public_url  varchar2(4000 byte),
    mime_type   varchar2(200 byte),
    created_by  varchar2(200 byte),
    created_at  timestamp(6) default systimestamp
);

alter table sublevel_attachments add primary key ( attach_id )
    using index enable;

