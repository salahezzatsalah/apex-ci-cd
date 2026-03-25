-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463854937 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\drive_crud.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/drive_crud.sql:null:686a601a7cc13cbc2692eaa554519bdf6723becf:create

create or replace package body drive_crud is

    g_bucket varchar2(400);

  -------------------------------
  -- Bucket handling
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

  -------------------------------
  -- Create folder
    function create_folder (
        p_parent_id   in varchar2,
        p_folder_name in varchar2
    ) return varchar2 is

        v_cnt         number;
        v_item_id     varchar2(300);
        v_object_name varchar2(1000);
        v_url         varchar2(2000);
        v_resp        clob;
    begin
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

    -- Build object name
        if p_parent_id is not null then
            select
                object_name
            into v_object_name
            from
                drive_items
            where
                    item_id = p_parent_id
                and item_type = 'FOLDER'
                and nvl(is_deleted, 'N') = 'N';

            v_object_name := v_object_name
                             || p_folder_name
                             || '/';
        else
            v_object_name := p_folder_name || '/';
        end if;

        v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                 || '/n/axiuwmrz0vs3/b/'
                 || g_bucket
                 || '/o/'
                 || utl_url.escape(v_object_name, true);

        apex_web_service.g_request_headers.delete;
        apex_web_service.g_request_headers(1).name := 'Content-Length';
        apex_web_service.g_request_headers(1).value := '0';

    -- ⚡ Corrected: assign the response
        v_resp := apex_web_service.make_rest_request(
            p_url                  => v_url,
            p_http_method          => 'PUT',
            p_credential_static_id => 'o_storagekey',
            p_body_blob            => empty_blob()
        );

        insert into drive_items (
            parent_id,
            item_name,
            object_name
        ) values ( p_parent_id,
                   p_folder_name,
                   v_object_name ) returning item_id into v_item_id;

        commit;
        dbms_output.put_line('Folder created in OCI + DB: ' || p_folder_name);
        return v_item_id;
    exception
        when others then
            rollback;
            raise_application_error(-20021, 'create_folder failed: '
                                            || sqlerrm
                                            || ' | URL='
                                            || v_url);
    end create_folder;

  -------------------------------
  -- Upload file
    procedure upload_file (
        p_parent_id in varchar2,
        p_filename  in varchar2,
        p_blob      in blob
    ) is
        v_cnt         number;
        v_object_name varchar2(1000);
        v_url         varchar2(2000);
        v_resp        clob;
    begin
        select
            count(*)
        into v_cnt
        from
            drive_items
        where
                nvl(parent_id, '0') = nvl(p_parent_id, '0')
            and item_name = p_filename
            and item_type = 'FILE'
            and nvl(is_deleted, 'N') = 'N';

        if v_cnt > 0 then
            raise_application_error(-20005, 'Another file with that name already exists in this folder.');
        end if;
        if p_parent_id is not null then
            select
                object_name
            into v_object_name
            from
                drive_items
            where
                    item_id = p_parent_id
                and item_type = 'FOLDER'
                and nvl(is_deleted, 'N') = 'N';

            v_object_name := v_object_name || p_filename;
        else
            v_object_name := p_filename;
        end if;

        v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                 || '/n/axiuwmrz0vs3/b/'
                 || g_bucket
                 || '/o/'
                 || utl_url.escape(v_object_name, true);

        v_resp := apex_web_service.make_rest_request(
            p_url                  => v_url,
            p_http_method          => 'PUT',
            p_credential_static_id => 'o_storagekey',
            p_body_blob            => p_blob,
            p_transfer_timeout     => 600
        );

        insert into drive_items (
            parent_id,
            item_name,
            item_type,
            object_name
        ) values ( p_parent_id,
                   p_filename,
                   'FILE',
                   v_object_name );

        commit;
        dbms_output.put_line('File uploaded to OCI + DB: ' || p_filename);
    exception
        when others then
            rollback;
            raise_application_error(-20020, 'upload_file failed: '
                                            || sqlerrm
                                            || ' | URL='
                                            || v_url);
    end upload_file;
  -------------------------------
  -- Delete file
    procedure delete_file (
        p_item_id in varchar2,
        p_hard    in boolean
    ) is
        v_object_name varchar2(1000);
        v_url         varchar2(2000);
        l_dummy       blob;
    begin
        select
            object_name
        into v_object_name
        from
            drive_items
        where
                item_id = p_item_id
            and item_type = 'FILE'
            and nvl(is_deleted, 'N') = 'N';

        if p_hard then
            v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                     || '/n/axiuwmrz0vs3/b/'
                     || g_bucket
                     || '/o/'
                     || utl_url.escape(v_object_name, true);

            l_dummy := apex_web_service.make_rest_request_b(
                p_url                  => v_url,
                p_http_method          => 'DELETE',
                p_credential_static_id => 'o_storagekey'
            );

    -- Remove from DB
            delete from drive_items
            where
                item_id = p_item_id;

        else
    -- Soft delete
            update drive_items
            set
                is_deleted = 'Y',
                deleted_by = nvl(apex_application.g_user, user),
                deleted_at = systimestamp
            where
                item_id = p_item_id;

        end if;

        commit;
        dbms_output.put_line('File deleted: '
                             || p_item_id ||
            case
                when p_hard then
                    ' (hard)'
                else
                    ' (soft)'
            end
        );

    exception
        when no_data_found then
            raise_application_error(-20030, 'File not found: ' || p_item_id);
    end delete_file;

  -------------------------------
  -- Delete folder
    procedure delete_folder (
        p_item_id in varchar2,
        p_hard    in boolean
    ) is
        v_object_name varchar2(1000);
        v_url         varchar2(2000);
        v_cnt         number;
        v_resp        clob;
    begin
  -- 1) Check if folder is empty
        select
            count(*)
        into v_cnt
        from
            drive_items
        where
                nvl(parent_id, '0') = p_item_id
            and nvl(is_deleted, 'N') = 'N';

        if v_cnt > 0 then
            raise_application_error(-20031, 'Folder not empty, delete children first: ' || p_item_id);
        end if;

  -- 2) Get folder object name
        select
            object_name
        into v_object_name
        from
            drive_items
        where
                item_id = p_item_id
            and item_type = 'FOLDER'
            and nvl(is_deleted, 'N') = 'N';

  -- 3) Hard delete: remove from OCI and DB
        if p_hard then
            v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                     || '/n/axiuwmrz0vs3/b/'
                     || g_bucket
                     || '/o/'
                     || utl_url.escape(v_object_name, true);

    -- Send DELETE request to OCI
            v_resp := apex_web_service.make_rest_request(
                p_url                  => v_url,
                p_http_method          => 'DELETE',
                p_credential_static_id => 'o_storagekey'
            );

    -- Remove folder from DB
            delete from drive_items
            where
                item_id = p_item_id;

        else
    -- Soft delete: mark as deleted
            update drive_items
            set
                is_deleted = 'Y',
                deleted_by = nvl(apex_application.g_user, user),
                deleted_at = systimestamp
            where
                    item_id = p_item_id
                and item_type = 'FOLDER';

        end if;

        commit;
        dbms_output.put_line('Folder deleted: '
                             || p_item_id ||
            case
                when p_hard then
                    ' (hard, OCI + DB)'
                else
                    ' (soft)'
            end
        );

    exception
        when no_data_found then
            raise_application_error(-20032, 'Folder not found: ' || p_item_id);
    end delete_folder;

-------------------------------
-- Get file by ITEM_ID
    function get_file_by_id (
        p_item_id in varchar2
    ) return t_file_result is

        l_result      t_file_result;
        l_object_name varchar2(1000);
        l_file_name   varchar2(255);
        l_blob        blob;
        l_mime        varchar2(255);
        l_content_len number;
        l_etag        varchar2(200);
        l_last_mod    varchar2(200);
    begin
        if p_item_id is null then
            raise_application_error(-20001, 'Missing ITEM_ID.');
        end if;

    -- Get object name and file name from DB
        select
            object_name,
            item_name
        into
            l_object_name,
            l_file_name
        from
            drive_items
        where
                item_id = p_item_id
            and nvl(is_deleted, 'N') = 'N';

    -- Fetch file from OCI
        l_result.response := apex_web_service.make_rest_request_b(
            p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                     || g_bucket
                     || '/o/'
                     || utl_url.escape(l_object_name, true),
            p_http_method          => 'GET',
            p_credential_static_id => 'o_storagekey'
        );

-- loop over headers
        for i in 1..apex_web_service.g_headers.count loop
            if upper(apex_web_service.g_headers(i).name) = 'CONTENT-TYPE' then
                l_mime := apex_web_service.g_headers(i).value;
            elsif upper(apex_web_service.g_headers(i).name) = 'CONTENT-LENGTH' then
                l_content_len := to_number ( apex_web_service.g_headers(i).value );
            elsif upper(apex_web_service.g_headers(i).name) = 'ETAG' then
                l_etag := apex_web_service.g_headers(i).value;
            elsif upper(apex_web_service.g_headers(i).name) = 'LAST-MODIFIED' then
                l_last_mod := apex_web_service.g_headers(i).value;
            end if;
        end loop;

-- assign to result record
        l_result.object_name := l_object_name;
        l_result.file_name := l_file_name;
        l_result.mime_type := l_mime;
        l_result.content_length := l_content_len;
        l_result.etag := l_etag;
        l_result.last_modified := l_last_mod;
        l_result.status_code := apex_web_service.g_status_code;
        return l_result;
    exception
        when no_data_found then
            raise_application_error(-20033, 'File not found for ITEM_ID=' || p_item_id);
        when others then
            l_result.object_name := null;
            l_result.file_name := null;
            l_result.response := empty_blob();
            l_result.mime_type := null;
            l_result.content_length := null;
            l_result.etag := null;
            l_result.last_modified := null;
            l_result.status_code := sqlcode;
            return l_result;
    end get_file_by_id;

    function rename_file (
        p_item_id  in varchar2,
        p_new_name in varchar2
    ) return varchar2 is

        v_old_object_name varchar2(1000);
        v_new_object_name varchar2(1000);
        v_parent_object   varchar2(300);
        v_o_count         number;
        v_o_response      clob;
    begin
    -- 1) Get current file info directly from DB
        select
            object_name,
            nvl(parent_id, '0')
        into
            v_old_object_name,
            v_parent_object
        from
            drive_items
        where
                item_id = p_item_id
            and item_type = 'FILE';

    -- 2) Check for name conflict in the same folder
        if v_parent_object != '0' then
            select
                count(*)
            into v_o_count
            from
                drive_items
            where
                    nvl(parent_id, '0') = v_parent_object
                and item_name = p_new_name
                and item_type = 'FILE';

            if v_o_count > 0 then
                raise_application_error(-20042, 'Another file with that name already exists in this folder.');
            end if;
        end if;

    -- 3) Build new object name
        if v_parent_object != '0' then
            select
                object_name
            into v_parent_object
            from
                drive_items
            where
                item_id = v_parent_object;

            v_new_object_name := v_parent_object || p_new_name;
        else
            v_new_object_name := p_new_name;
        end if;

    -- 4) Try to copy file in OCI; ignore errors if object not found
        begin
            v_o_response := apex_web_service.make_rest_request(
                p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                         || g_bucket
                         || '/o/'
                         || utl_url.escape(v_new_object_name, true),
                p_http_method          => 'PUT',
                p_credential_static_id => 'o_storagekey',
                p_body_blob            => apex_web_service.make_rest_request_b(
                    p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                             || g_bucket
                             || '/o/'
                             || utl_url.escape(v_old_object_name, true),
                    p_http_method          => 'GET',
                    p_credential_static_id => 'o_storagekey'
                )
            );
        -- 5) Delete old object in OCI
            v_o_response := apex_web_service.make_rest_request(
                p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                         || g_bucket
                         || '/o/'
                         || utl_url.escape(v_old_object_name, true),
                p_http_method          => 'DELETE',
                p_credential_static_id => 'o_storagekey'
            );

        exception
            when others then
                dbms_output.put_line('OCI rename failed, will update DB only: ' || sqlerrm);
        end;

    -- 6) Update DB
        update drive_items
        set
            item_name = p_new_name,
            object_name = v_new_object_name
        where
            item_id = p_item_id;

        commit;
        return v_new_object_name;
    exception
        when others then
            rollback;
            raise_application_error(-20043, 'rename_file failed: ' || sqlerrm);
    end rename_file;

    function rename_folder (
        p_item_id  in varchar2,
        p_new_name in varchar2
    ) return varchar2 is

        v_old_object_name varchar2(1000);
        v_new_object_name varchar2(1000);
        v_parent_object   varchar2(1000);
        v_resp            clob;
    begin
    -- 1) Get current folder info
        select
            object_name,
            nvl(parent_id, '0')
        into
            v_old_object_name,
            v_parent_object
        from
            drive_items
        where
                item_id = p_item_id
            and item_type = 'FOLDER'
            and nvl(is_deleted, 'N') = 'N';

    -- 2) Check for conflict under same parent
        declare
            v_cnt number;
        begin
            select
                count(*)
            into v_cnt
            from
                drive_items
            where
                    nvl(parent_id, '0') = nvl(v_parent_object, '0')
                and item_name = p_new_name
                and item_type = 'FOLDER'
                and nvl(is_deleted, 'N') = 'N';

            if v_cnt > 0 then
                raise_application_error(-20044, 'Another folder with that name already exists in this location.');
            end if;
        end;

    -- 3) Build new object name
        if v_parent_object != '0' then
            select
                object_name
            into v_parent_object
            from
                drive_items
            where
                item_id = v_parent_object;

            v_new_object_name := v_parent_object
                                 || p_new_name
                                 || '/';
        else
            v_new_object_name := p_new_name || '/';
        end if;

    -- 4) Fetch all nested objects (folders + files) ordered deepest first
        for rec in (
            select
                item_id,
                object_name,
                item_type
            from
                drive_items
            where
                object_name like v_old_object_name || '%'
            order by
                length(object_name) desc
        ) loop
        -- Compute new object name for each nested object
            declare
                v_nested_new_name varchar2(1000);
            begin
                v_nested_new_name := replace(rec.object_name, v_old_object_name, v_new_object_name);

            -- Copy object in OCI
                v_resp := apex_web_service.make_rest_request(
                    p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                             || g_bucket
                             || '/o/'
                             || utl_url.escape(v_nested_new_name, true),
                    p_http_method          => 'PUT',
                    p_credential_static_id => 'o_storagekey',
                    p_body_blob            => apex_web_service.make_rest_request_b(
                           p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                                    || g_bucket
                                    || '/o/'
                                    || utl_url.escape(rec.object_name, true),
                           p_http_method          => 'GET',
                           p_credential_static_id => 'o_storagekey'
                       )
                );

            -- Delete old object in OCI
                v_resp := apex_web_service.make_rest_request(
                    p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                             || g_bucket
                             || '/o/'
                             || utl_url.escape(rec.object_name, true),
                    p_http_method          => 'DELETE',
                    p_credential_static_id => 'o_storagekey'
                );

            -- Update DB
                update drive_items
                set
                    object_name = v_nested_new_name
                where
                    item_id = rec.item_id;

            end;
        end loop;

    -- 5) Update folder record
        update drive_items
        set
            item_name = p_new_name,
            object_name = v_new_object_name
        where
            item_id = p_item_id;

        commit;
        dbms_output.put_line('Folder renamed successfully (including nested objects): ' || p_item_id);
        return v_new_object_name;
    exception
        when others then
            rollback;
            raise_application_error(-20045, 'rename_folder failed: ' || sqlerrm);
    end rename_folder;

end drive_crud;
/

