-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463883697 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\media_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/media_pkg.sql:null:328569ef8cd05e72c7966468347839641d9a1d6b:create

create or replace package media_pkg as

  /* Upload file from APEX temp to OCI and return PAR URL */
    function upload_from_temp (
        p_bucket_folder in varchar2,  -- e.g. CAR_TYPES_MAIN
        p_temp_name     in varchar2,  -- apex temp file name
        p_object_name   in varchar2,  -- file name in bucket
        p_par_prefix    in varchar2,  -- prefix for par name
        p_exp_months    in number default 12
    ) return varchar2;

  /* Delete single object */
    procedure delete_object (
        p_object_path in varchar2
    );

  /* Delete full folder */
    procedure delete_folder (
        p_folder_path in varchar2
    );

end media_pkg;
/

