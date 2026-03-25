-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463855847 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\drive_crud_api.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/drive_crud_api.sql:null:e825ab6463c1ebc0b5f7597b1c12fe5b1458eb4c:create

create or replace package body drive_crud_api is

    g_bucket            varchar2(400);
      -- Cache للأسماء وملفات الـ BLOB
    g_file_cache        sys.odcivarchar2list;  -- لتخزين أسماء الملفات
    g_file_result_cache sys.odcirawlist;       -- لتخزين محتوى الملفات (BLOB)

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

    procedure cache_file (
        p_item_id in varchar2,
        p_blob    in blob
    ) is
    begin
        if g_file_cache is null then
            g_file_cache := sys.odcivarchar2list();
            g_file_result_cache := sys.odcirawlist();
        end if;

        g_file_cache.extend;
        g_file_cache(g_file_cache.count) := p_item_id;
        g_file_result_cache.extend;
        g_file_result_cache(g_file_result_cache.count) := p_blob;
    end cache_file;

    procedure create_folder (
        p_parent_name in varchar2,
        p_folder_name in varchar2
    ) is
        v_object_name varchar2(1000);
        v_url         varchar2(2000);
        v_resp        clob;
        v_status_code pls_integer;
    begin
        if p_folder_name is null
           or trim(p_folder_name) is null then
            raise_application_error(-20020, 'Folder name cannot be null or empty');
        end if;

        if
            p_parent_name is not null
            and trim(p_parent_name) is not null
        then
            v_object_name := p_parent_name
                             || '/'
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

    -- v_resp := apex_web_service.make_rest_request(
    --     p_url                  => v_url,
    --     p_http_method          => 'HEAD',
    --     p_credential_static_id => 'o_storagekey'
    -- );
    -- v_status_code := apex_web_service.g_status_code;

    -- IF v_status_code = 200 THEN
    --     RAISE_APPLICATION_ERROR(-20022, 'Folder already exists: ' || v_object_name);
    -- ELSIF v_status_code != 404 THEN
    --     RAISE_APPLICATION_ERROR(-20024,
    --         'Error checking folder existence. HTTP ' || v_status_code);
    -- END IF;
        apex_web_service.g_request_headers.delete;
        apex_web_service.g_request_headers(1).name := 'Content-Length';
        apex_web_service.g_request_headers(1).value := '0';
        v_resp := apex_web_service.make_rest_request(
            p_url                  => v_url,
            p_http_method          => 'PUT',
            p_credential_static_id => app_config.g_credential_id,
            p_body_blob            => empty_blob()
        );

        v_status_code := apex_web_service.g_status_code;
        if v_status_code = 200
        or v_status_code = 201 then
            dbms_output.put_line('Folder created successfully: ' || v_object_name);
        else
            raise_application_error(-20021,
                                    'Failed to create folder. HTTP status: '
                                    || v_status_code
                                    || ' Response: '
                                    || dbms_lob.substr(v_resp, 2000));
        end if;

    exception
        when others then
            raise_application_error(-20021, 'Unexpected error in create_folder: ' || sqlerrm);
    end create_folder;

    function get_file_by_id (
        p_item_id in varchar2
    ) return t_file_result is
        l_result    t_file_result;
        l_file_name varchar2(255);
    begin
        if p_item_id is null then
            raise_application_error(-20001, 'Missing ITEM_ID.');
        end if;

    -- ===== تحقق أولاً من in-memory cache =====
        if g_file_cache is not null then
            for i in 1..g_file_cache.count loop
                if g_file_cache(i) = p_item_id then
                    l_result.object_name := p_item_id;
                    l_result.file_name := substr(p_item_id,
                                                 instr(p_item_id, '/', -1) + 1);

                    l_result.response := g_file_result_cache(i);  -- استرجاع المحتوى من الذاكرة
                    return l_result;  -- رجع مباشرة بدون REST call
                end if;
            end loop;

        end if;

    -- ===== REST call لجلب الملف لو مش موجود في الذاكرة =====
        l_result.response := apex_web_service.make_rest_request_b(
            p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                     || g_bucket
                     || '/o/'
                     || utl_url.escape(p_item_id, true),
            p_http_method          => 'GET',
            p_credential_static_id => app_config.g_credential_id
        );

        l_result.object_name := p_item_id;
        l_result.file_name := substr(p_item_id,
                                     instr(p_item_id, '/', -1) + 1);

    -- ===== خزّن في الذاكرة بعد الـ GET =====
        cache_file(p_item_id, l_result.response);
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

    procedure delete_folder (
        p_full_name in varchar2
    ) is

        v_object_name   clob;
        l_response      clob;
        l_json_obj      json_object_t;
        l_objects_array json_array_t;
        l_count         pls_integer := 0;
        l_item_name     clob;
        l_item_obj      json_object_t;
        l_deleted_count number := 0;
    begin
        if p_full_name is null
           or length(trim(p_full_name)) = 0 then
            raise_application_error(-20041, 'Folder name cannot be null or empty');
        end if;

    -- Ensure trailing slash for folder prefix
        v_object_name :=
            case
                when substr(p_full_name, -1) = '/' then
                    p_full_name
                else
                    p_full_name || '/'
            end;

    -- 1. List all objects under folder prefix
        apex_web_service.g_request_headers.delete;
        apex_web_service.g_request_headers(1).name := 'Accept';
        apex_web_service.g_request_headers(1).value := 'application/json';
        l_response := apex_web_service.make_rest_request(
            p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                     || g_bucket
                     || '/o?prefix='
                     || utl_url.escape(v_object_name, true),
            p_http_method          => 'GET',
            p_credential_static_id => app_config.g_credential_id
        );

        apex_web_service.g_request_headers.delete;

    -- 2. Parse JSON response
        l_json_obj := json_object_t.parse(l_response);
        if l_json_obj.has('objects') then
            l_objects_array := l_json_obj.get_array('objects');
            l_count := l_objects_array.get_size();
        else
            l_count := 0;
        end if;

    -- 3. Delete files (skip folder placeholders)
        if l_count > 0 then
            for i in 0..l_count - 1 loop
                begin
                    l_item_obj := treat(l_objects_array.get(i) as json_object_t);
                    l_item_name := l_item_obj.get_string('name');
                    if
                        l_item_name is not null
                        and length(trim(l_item_name)) > 0
                    then
                        if substr(l_item_name, -1) = '/' then
                        -- skip folder placeholder for now
                            null;
                        else
                            drive_crud_api.delete_file(l_item_name);
                            l_deleted_count := l_deleted_count + 1;
                        end if;
                    end if;

                exception
                    when others then
                        dbms_output.put_line('Warning: Failed to delete '
                                             || l_item_name
                                             || ': ' || sqlerrm);
                end;
            end loop;
        end if;

    -- 4. Delete the folder placeholder itself
        begin
            l_response := apex_web_service.make_rest_request(
                p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                         || g_bucket
                         || '/o/'
                         || utl_url.escape(v_object_name, true),
                p_http_method          => 'DELETE',
                p_credential_static_id => app_config.g_credential_id
            );

            dbms_output.put_line('Folder placeholder deleted: ' || v_object_name);
        exception
            when others then
                dbms_output.put_line('Folder placeholder not found or already deleted: ' || v_object_name);
        end;

    -- 5. Final log
        dbms_output.put_line('Folder deletion completed: '
                             || v_object_name
                             || ' | Files deleted: '
                             || l_deleted_count
                             || ' | Total objects found: ' || l_count);

    exception
        when others then
            apex_web_service.g_request_headers.delete;
            raise_application_error(-20032, 'delete_folder failed ['
                                            || p_full_name
                                            || ']: '
                                            || sqlerrm);
    end delete_folder;

    function get_file (
        p_item_id in varchar2
    ) return t_file_result is

        l_result      t_file_result;
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

    -- Perform REST call
        l_blob := apex_web_service.make_rest_request_b(
            p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                     || g_bucket
                     || '/o/'
                     || utl_url.escape(p_item_id, true),
            p_http_method          => 'GET',
            p_credential_static_id => app_config.g_credential_id
        );

    -- Parse headers
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

    -- Extract file name from object path
        l_file_name := substr(p_item_id,
                              instr(p_item_id, '/', -1) + 1);

    -- Build result
        l_result.object_name := p_item_id;
        l_result.file_name := l_file_name;
        l_result.response := l_blob;
        l_result.mime_type := l_mime;
        l_result.content_length := nvl(l_content_len,
                                       dbms_lob.getlength(l_blob));
        l_result.etag := l_etag;
        l_result.last_modified := l_last_mod;
        l_result.status_code := apex_web_service.g_status_code;
        return l_result;
    exception
        when no_data_found then
            raise_application_error(-20033, 'File not found for ITEM_ID=' || p_item_id);
        when others then
            l_result.object_name := p_item_id;
            l_result.file_name := null;
            l_result.response := empty_blob();
            l_result.mime_type := null;
            l_result.content_length := null;
            l_result.etag := null;
            l_result.last_modified := null;
            l_result.status_code := sqlcode;
            return l_result;
    end get_file;

    procedure rename_object (
        p_old_name in varchar2,
        p_new_name in varchar2
    ) is
        v_url  varchar2(4000);
        v_body clob;
        v_resp clob;
    begin
        v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                 || '/n/axiuwmrz0vs3/b/'
                 || g_bucket
                 || '/actions/renameObject';
        v_body := '{'
                  || '"sourceName":"'
                  || p_old_name
                  || '",'
                  || '"newName":"'
                  || p_new_name
                  || '"'
                  || '}';

    -- Headers
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';

    -- REST call
        v_resp := apex_web_service.make_rest_request(
            p_url                  => v_url,
            p_http_method          => 'POST',
            p_credential_static_id => app_config.g_credential_id,  -- your OCI Web Credential
            p_body                 => v_body,
            p_transfer_timeout     => 600
        );

        dbms_output.put_line('Rename response: ' || v_resp);
    exception
        when others then
            raise_application_error(-20044, 'rename_object failed: ' || sqlerrm);
    end rename_object;
    -------------------------------
  -- Create Pre-Authenticated Request (PAR) for a folder/object
    function create_par (
        p_object_name  in varchar2,
        p_par_name     in varchar2,
        p_time_expires in timestamp
    ) return varchar2 is
        v_url        varchar2(4000);
        v_resp       clob;
        v_json_body  clob;
        v_access_uri varchar2(4000);
    begin
    -- Endpoint URL
        v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                 || g_bucket
                 || '/p/';

    -- JSON body for PAR
        v_json_body := '{
        "name": "'
                       || p_par_name
                       || '",
        "accessType": "ObjectRead",
        "timeExpires": "'
                       || to_char(p_time_expires, 'YYYY-MM-DD"T"HH24:MI:SS"Z"')
                       || '",
        "objectName": "'
                       || p_object_name
                       || '"
    }';

    -- Set headers
        apex_web_service.g_request_headers.delete;
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';
        apex_web_service.g_request_headers(2).name := 'opc-client-request-id';
        apex_web_service.g_request_headers(2).value := 'REQ_' || to_char(systimestamp, 'YYYYMMDDHH24MISS');

    -- Make REST request using stored OCI credential
        v_resp := apex_web_service.make_rest_request(
            p_url                  => v_url,
            p_http_method          => 'POST',
            p_credential_static_id => app_config.g_credential_id,
            p_body                 => v_json_body,
            p_transfer_timeout     => 600
        );

    -- Parse accessUri from JSON response
        apex_json.parse(v_resp);
        v_access_uri := apex_json.get_varchar2('accessUri');
        dbms_output.put_line('PAR URL created: ' || v_access_uri);
        return v_access_uri;
    exception
        when others then
            raise_application_error(-20050, 'create_par failed: '
                                            || sqlerrm
                                            || ' | JSON='
                                            || v_json_body);
    end create_par;

    procedure upload_file (
        p_parent_name in varchar2,
        p_filename    in varchar2,
        p_blob        in blob
    ) is
        v_object_name varchar2(1000);
        v_url         varchar2(2000);
        v_resp        clob;
    begin
        if p_parent_name is not null then
            v_object_name := p_parent_name
                             || '/'
                             || p_filename;
        else
            v_object_name := p_filename;
        end if;

        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'image/webp';
        v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                 || '/n/axiuwmrz0vs3/b/'
                 || g_bucket
                 || '/o/'
                 || utl_url.escape(v_object_name, true);

        v_resp := apex_web_service.make_rest_request(
            p_url                  => v_url,
            p_http_method          => 'PUT',
            p_credential_static_id => app_config.g_credential_id,
            p_body_blob            => p_blob,
            p_transfer_timeout     => 600
        );

        dbms_output.put_line('File uploaded to OCI: ' || v_object_name);
        cache_file(v_object_name, null);

    -- INSERT INTO supplier_file_cache(object_name) VALUES (v_object_name);
    -- COMMIT;
    exception
        when others then
            raise_application_error(-20020, 'upload_file failed: '
                                            || sqlerrm
                                            || ' | URL='
                                            || v_url);
    end upload_file;

    procedure delete_file (
        p_full_name in varchar2
    ) is
        v_url   varchar2(2000);
        l_dummy blob;
    begin
        if p_full_name is null
           or trim(p_full_name) is null then
            raise_application_error(-20031, 'File name cannot be null or empty');
        elsif substr(p_full_name, -1) = '/' then
            raise_application_error(-20032, 'Invalid file name (folder-like path not allowed): ' || p_full_name);
        end if;

        v_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                 || '/n/axiuwmrz0vs3/b/'
                 || g_bucket
                 || '/o/'
                 || utl_url.escape(p_full_name, true);

        l_dummy := apex_web_service.make_rest_request_b(
            p_url                  => v_url,
            p_http_method          => 'DELETE',
            p_credential_static_id => app_config.g_credential_id
        );

        if apex_web_service.g_status_code = 204 then
            dbms_output.put_line('File deleted: ' || p_full_name);
        elsif apex_web_service.g_status_code = 404 then
            raise_application_error(-20034, 'File not found: ' || p_full_name);
        else
            raise_application_error(-20033, 'Unexpected response ['
                                            || apex_web_service.g_status_code
                                            || '] while deleting file: '
                                            || p_full_name);
        end if;

    exception
        when others then
            raise_application_error(-20030, 'delete_file failed ['
                                            || p_full_name
                                            || ']: '
                                            || sqlerrm);
    end delete_file;

    procedure undelete_object (
        p_object_name in varchar2
    ) is

        l_namespace  varchar2(100) := 'axiuwmrz0vs3';
        l_json       clob;
        l_obj_count  pls_integer;
        l_version_id varchar2(1000);
        l_is_delete  boolean;
        l_resp       clob;
    begin
    -- 1. List object versions
        l_json := apex_web_service.make_rest_request(
            p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/'
                     || l_namespace
                     || '/b/'
                     || g_bucket
                     || '/objectversions?prefix='
                     || utl_url.escape(p_object_name, true),
            p_http_method          => 'GET',
            p_credential_static_id => app_config.g_credential_id
        );

        dbms_output.put_line('JSON response: ' || l_json);

    -- 2. Parse JSON
        apex_json.parse(l_json);
        l_obj_count := apex_json.get_count('items');
        l_version_id := null;
        for i in 1..l_obj_count loop
            l_is_delete := apex_json.get_boolean('items[%d].isDeleteMarker', i);
            if l_is_delete then
                l_version_id := apex_json.get_varchar2('items[%d].versionId', i);
                exit;
            end if;

        end loop;

        if l_version_id is null then
            dbms_output.put_line('No delete marker found. Object may not be deleted.');
            return;
        end if;
        dbms_output.put_line('Delete marker versionId found: ' || l_version_id);
        l_resp := apex_web_service.make_rest_request(
            p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/'
                     || l_namespace
                     || '/b/'
                     || g_bucket
                     || '/o/'
                     || utl_url.escape(p_object_name, true)
                     || '?versionId='
                     || l_version_id,
            p_http_method          => 'DELETE',
            p_credential_static_id => app_config.g_credential_id
        );

        dbms_output.put_line('Delete marker removed. Object restored.');
        dbms_output.put_line('Response: ' || l_resp);
    exception
        when others then
            dbms_output.put_line('Error in undelete_object: ' || sqlerrm);
    end undelete_object;

end drive_crud_api;
/

