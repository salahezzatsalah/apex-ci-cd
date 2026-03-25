create or replace package drive_crud_api is
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
    function get_file (
        p_item_id in varchar2
    ) return t_file_result;

    procedure set_bucket (
        p_bucket in varchar2
    );

    function get_bucket return varchar2;

    procedure create_folder (
        p_parent_name in varchar2,
        p_folder_name in varchar2
    );

    function get_file_by_id (
        p_item_id in varchar2
    ) return t_file_result;

    function create_par (
        p_object_name  in varchar2,
        p_par_name     in varchar2,
        p_time_expires in timestamp
    ) return varchar2;

    procedure delete_folder (
        p_full_name in varchar2
    );

    procedure upload_file (
        p_parent_name in varchar2,
        p_filename    in varchar2,
        p_blob        in blob
    );

    procedure delete_file (
        p_full_name in varchar2
    );

    procedure rename_object (
        p_old_name in varchar2,
        p_new_name in varchar2
    );

    procedure undelete_object (
        p_object_name in varchar2
    );

end drive_crud_api;
/


-- sqlcl_snapshot {"hash":"59a30fbd52012bf4fc4d9c932d69465036af4d40","type":"PACKAGE_SPEC","name":"DRIVE_CRUD_API","schemaName":"WKSP_ELWAGHA50","sxml":""}