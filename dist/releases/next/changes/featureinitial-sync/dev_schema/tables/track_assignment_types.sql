-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464039600 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\track_assignment_types.sql
-- sqlcl_snapshot src/database/dev_schema/tables/track_assignment_types.sql:null:63a3c9d3d8884b9399a746f7e1cc53f7798f2613:create

create table track_assignment_types (
    assignment_type_code    varchar2(30 byte),
    assignment_type_name_en varchar2(100 byte),
    assignment_type_name_ar varchar2(100 byte),
    description             varchar2(500 byte),
    is_active               char(1 byte),
    display_order           number(3, 0),
    created_by              varchar2(30 byte),
    updated_by              varchar2(30 byte),
    created                 timestamp(6) with time zone,
    updated                 timestamp(6) with time zone
);

