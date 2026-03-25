-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463878787 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\file_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/file_pkg.sql:null:dd331b4c231a01c697161fe39d8515ac7e56e373:create

create or replace package file_pkg as
    type t_file_result is record (
            object_name    varchar2(1000),
            file_name      varchar2(255),
            response       blob,
            mime_type      varchar2(255),
            content_length number,
            etag           varchar2(255),
            last_modified  varchar2(255),
            status_code    number
    );
    function download_folder_zip (
        p_folder_prefix in varchar2
    ) return t_file_result;

end file_pkg;
/

