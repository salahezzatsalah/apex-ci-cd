-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464029520 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\search_config.sql
-- sqlcl_snapshot src/database/dev_schema/tables/search_config.sql:null:3c480e11ebd22e4fd5882da8b188883ca4ecace8:create

create table search_config (
    id                    number generated always as identity not null enable,
    source_name           varchar2(100 byte),
    table_name            varchar2(100 byte),
    pk_column             varchar2(100 byte),
    search_fields         varchar2(1000 byte),
    label_template        varchar2(1000 byte),
    subtitle_template     varchar2(1000 byte),
    description_template  varchar2(2000 byte),
    avatar_blob           varchar2(100 byte),
    avatar_blob_page_item varchar2(100 byte),
    placeholder_img       varchar2(255 byte),
    target_page           number,
    target_item           varchar2(100 byte),
    enabled               varchar2(1 byte) default 'Y'
);

alter table search_config add primary key ( id )
    using index enable;

