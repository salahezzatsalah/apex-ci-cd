create or replace package body drive_folder_pkg is

    g_bucket varchar2(400);

    procedure set_bucket (
        p_bucket in varchar2
    ) is
    begin
        g_bucket := p_bucket;
    end set_bucket;

    function get_bucket return varchar2 is
    begin
        return g_bucket;
    end get_bucket;

    function create_folder (
        p_parent_id   in varchar2,
        p_folder_name in varchar2,
        p_created_by  in varchar2
    ) return varchar2 is

        v_cnt         number;
        v_item_id     varchar2(300);
        v_object_name varchar2(1000);
        v_parent_path varchar2(1000);
        v_url         varchar2(2000);
        v_resp        clob;
    begin
    -- Prevent duplicates under same parent
        select
            count(*)
        into v_cnt
        from
            drive_items
        where
                nvl(parent_id, '0') = nvl(p_parent_id, '0')
            and item_name = p_folder_name
            and item_type = 'FOLDER'
            and nvl(is_deleted, 'N') = 'N';

        if v_cnt > 0 then
            raise_application_error(-20006, 'Another folder with that name already exists in this location.');
        end if;

    -- Build folder path
        if p_parent_id is not null then
            select
                object_name
            into v_parent_path
            from
                drive_items
            where
                    item_id = p_parent_id
                and item_type = 'FOLDER'
                and nvl(is_deleted, 'N') = 'N';

            v_object_name := v_parent_path
                             || p_folder_name
                             || '/';
        else
            v_object_name := p_folder_name || '/';
        end if;

    -- Build OCI URL
        v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                 || '/n/axiuwmrz0vs3'
                 || '/b/'
                 || g_bucket
                 || '/o/'
                 || utl_url.escape(v_object_name, true);

    -- Add Content-Length header
        apex_web_service.g_request_headers.delete;
        apex_web_service.g_request_headers(1).name := 'Content-Length';
        apex_web_service.g_request_headers(1).value := '0';

    -- PUT empty body (folder marker)
        v_resp := apex_web_service.make_rest_request(
            p_url                  => v_url,
            p_http_method          => 'PUT',
            p_credential_static_id => 'o_storagekey',
            p_body_blob            => empty_blob()
        );

    -- Insert metadata
        insert into drive_items (
            parent_id,
            item_name,
            item_type,
            object_name,
            created_by
        ) values ( p_parent_id,
                   p_folder_name,
                   'FOLDER',
                   v_object_name,
                   p_created_by ) returning item_id into v_item_id;

        commit;
        dbms_output.put_line('📂 Folder created at path: ' || v_object_name);
        return v_item_id;
    exception
        when no_data_found then
            raise_application_error(-20022, 'Parent folder not found for ID=' || p_parent_id);
        when others then
            rollback;
            raise_application_error(-20021, 'create_folder failed: '
                                            || sqlerrm
                                            || ' | URL='
                                            || v_url);
    end create_folder;

end drive_folder_pkg;
/


-- sqlcl_snapshot {"hash":"4f15a9c5ce0b69a5f7895b362bc3b2d04730c43f","type":"PACKAGE_BODY","name":"DRIVE_FOLDER_PKG","schemaName":"WKSP_ELWAGHA50","sxml":""}