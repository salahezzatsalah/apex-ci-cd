-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463987370 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_classifications_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_classifications_types.sql:null:bea7c1f8aadd9781f8f270b9d6da7024bf456ed2:create

create table limo_classifications_types (
    classification_code     varchar2(20 byte),
    classification_label_ar varchar2(50 byte),
    classification_label_en varchar2(50 byte),
    active_yn               varchar2(1 byte) default 'Y'
);

alter table limo_classifications_types add primary key ( classification_code )
    using index enable;

