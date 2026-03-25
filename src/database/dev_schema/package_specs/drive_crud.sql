create or replace package drive_crud is
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

  -- Bucket handling
    procedure set_bucket (
        p_bucket in varchar2
    );

    function get_bucket return varchar2;

  -- CRUD operations
    function create_folder (
        p_parent_id   in varchar2,
        p_folder_name in varchar2
    ) return varchar2;

    procedure upload_file (
        p_parent_id in varchar2,
        p_filename  in varchar2,
        p_blob      in blob
    );

  -- Delete operations
    procedure delete_file (
        p_item_id in varchar2,
        p_hard    in boolean default false  -- TRUE = hard delete, FALSE = soft delete
    );

    procedure delete_folder (
        p_item_id in varchar2,
        p_hard    in boolean default false  -- TRUE = hard delete, FALSE = soft delete
    );

    function get_file_by_id (
        p_item_id in varchar2
    ) return t_file_result;

    function rename_folder (
        p_item_id  in varchar2,
        p_new_name in varchar2
    ) return varchar2;

    function rename_file (
        p_item_id  in varchar2,
        p_new_name in varchar2
    ) return varchar2;

end drive_crud;
/


-- sqlcl_snapshot {"hash":"76bda05a9077018d744c2d549ab87c7913fc43ad","type":"PACKAGE_SPEC","name":"DRIVE_CRUD","schemaName":"DEV_SCHEMA","sxml":""}