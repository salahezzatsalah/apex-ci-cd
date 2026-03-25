-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463988385 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_collection_methods.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_collection_methods.sql:null:5aa7cea7e4a52bd09d19fdb39d999c2d2cfcd35d:create

create table limo_collection_methods (
    method_id     varchar2(50 byte),
    method_name   varchar2(100 byte),
    is_active     varchar2(1 byte) default 'Y',
    display_order number(5, 0),
    created       timestamp(6) default systimestamp,
    created_by    varchar2(100 byte),
    method_icon   varchar2(100 byte)
);

alter table limo_collection_methods add primary key ( method_id )
    using index enable;

