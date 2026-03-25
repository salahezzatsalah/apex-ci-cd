create or replace package body media_pkg as

/* =====================================================
   Upload file from APEX temp → OCI → PAR URL
===================================================== */

    function upload_from_temp (
        p_bucket_folder in varchar2,
        p_temp_name     in varchar2,
        p_object_name   in varchar2,
        p_par_prefix    in varchar2,
        p_exp_months    in number
    ) return varchar2 is

        l_blob        blob;
        l_filename    varchar2(500);
        l_object_path varchar2(1000);
        l_public_url  varchar2(4000);
    begin
        if p_temp_name is null then
            return null;
        end if;

  /* Read from APEX temp */
        select
            blob_content,
            filename
        into
            l_blob,
            l_filename
        from
            apex_application_temp_files
        where
                name = trim(p_temp_name)
            and rownum = 1;

        drive_crud_api.set_bucket(app_config.g_default_bucket);

  /* Build path */
        l_object_path := p_bucket_folder
                         || '/'
                         || p_object_name;

  /* Upload */
        drive_crud_api.upload_file(
            p_parent_name => p_bucket_folder,
            p_filename    => p_object_name,
            p_blob        => l_blob
        );

  /* Create PAR */
        l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                        || drive_crud_api.create_par(
            p_object_name  => l_object_path,
            p_par_name     => p_par_prefix
                          || '-'
                          || sys_guid(),
            p_time_expires => add_months(systimestamp, p_exp_months)
        );

  /* Cleanup temp */
        delete from apex_application_temp_files
        where
            name = trim(p_temp_name);

        return l_public_url;
    exception
        when no_data_found then
            return null;
        when others then
            raise_application_error(-20901, 'MEDIA upload failed: ' || sqlerrm);
    end upload_from_temp;


/* =====================================================
   Delete single object
===================================================== */

    procedure delete_object (
        p_object_path in varchar2
    ) is
    begin
        if p_object_path is null then
            return;
        end if;
        drive_crud_api.set_bucket(app_config.g_default_bucket);
        drive_crud_api.delete_file(p_object_path);
    exception
        when others then
            dbms_output.put_line('MEDIA delete_object failed: ' || sqlerrm);
    end delete_object;


/* =====================================================
   Delete folder
===================================================== */

    procedure delete_folder (
        p_folder_path in varchar2
    ) is
    begin
        if p_folder_path is null then
            return;
        end if;
        drive_crud_api.set_bucket(app_config.g_default_bucket);
        drive_crud_api.delete_folder(p_folder_path);
    exception
        when others then
            dbms_output.put_line('MEDIA delete_folder failed: ' || sqlerrm);
    end delete_folder;

end media_pkg;
/


-- sqlcl_snapshot {"hash":"1316c8be4cc0d69b6f2f9004d1975fb74fe86af7","type":"PACKAGE_BODY","name":"MEDIA_PKG","schemaName":"WKSP_ELWAGHA50","sxml":""}