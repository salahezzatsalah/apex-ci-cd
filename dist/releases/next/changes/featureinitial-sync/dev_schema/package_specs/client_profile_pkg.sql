-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463876393 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\client_profile_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/client_profile_pkg.sql:null:ebe030297f9fb33fa0e30938c3ead2b777a2cc56:create

create or replace package client_profile_pkg as
    procedure update_profile (
        p_token           in varchar2,
        p_full_name       in varchar2 default null,
        p_country_code    in varchar2 default null,
        p_phone_number    in varchar2 default null,
        p_date_of_birth   in date default null,
        p_nationality     in varchar2 default null,
        p_email           in varchar2 default null,
        p_photo_blob      in blob default null,
        p_photo_mime_type in varchar2 default null,
        p_photo_filename  in varchar2 default null,
        p_image_url       out varchar2
    );

    procedure delete_user (
        p_token      in varchar2,
        p_debug_json out clob
    );

end client_profile_pkg;
/

