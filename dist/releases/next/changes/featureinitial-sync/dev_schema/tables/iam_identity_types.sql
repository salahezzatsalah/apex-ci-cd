-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463961672 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_identity_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_identity_types.sql:null:bd2e71fbb36510200712c0755e5428352a28a245:create

create table iam_identity_types (
    type_code    varchar2(50 byte),
    type_name    varchar2(150 byte),
    is_active_yn varchar2(1 byte) default 'Y'
);

alter table iam_identity_types add primary key ( type_code )
    using index enable;

