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


-- sqlcl_snapshot {"hash":"ebe030297f9fb33fa0e30938c3ead2b777a2cc56","type":"PACKAGE_SPEC","name":"CLIENT_PROFILE_PKG","schemaName":"DEV_SCHEMA","sxml":""}