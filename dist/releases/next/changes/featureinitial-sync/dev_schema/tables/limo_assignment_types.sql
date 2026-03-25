-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463978867 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_assignment_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_assignment_types.sql:null:ca419792c8049f03b0b9dc39e420e869f306d737:create

create table limo_assignment_types (
    assignment_type_code    varchar2(30 byte),
    assignment_type_name_en varchar2(100 byte),
    assignment_type_name_ar varchar2(100 byte),
    description             varchar2(500 byte),
    is_active               char(1 byte) default 'Y',
    display_order           number(3, 0),
    created_by              varchar2(30 byte),
    updated_by              varchar2(30 byte),
    created                 timestamp(6) with time zone,
    updated                 timestamp(6) with time zone
);

alter table limo_assignment_types add primary key ( assignment_type_code )
    using index enable;

