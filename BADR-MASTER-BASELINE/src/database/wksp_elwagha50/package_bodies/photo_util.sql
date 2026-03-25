create or replace package body photo_util is

    procedure manage_record (
        p_action      in varchar2,
        p_table_name  in varchar2,
        p_id_column   in varchar2,
        p_id_value    in out varchar2,
        p_fields      in apex_t_varchar2,
        p_values      in apex_t_varchar2,
        p_page_item   in varchar2,
        p_folder_name in varchar2,
        p_url_column  in varchar2 default 'PHOTO_URL',
        p_date_column in varchar2 default 'PHOTO_LAST_UPDATED'
    ) is

        l_sql         clob;
        l_set_list    varchar2(4000);
        l_cols        varchar2(4000);
        l_vals        varchar2(4000);
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
        l_old_url     varchar2(4000);
    begin
        -- 🔹 INSERT
        if upper(p_action) = 'INSERT' then
            -- Build column list
            for i in 1..p_fields.count loop
                if i > 1 then
                    l_cols := l_cols || ', ';
                    l_vals := l_vals || ', ';
                end if;

                l_cols := l_cols || p_fields(i);
                l_vals := l_vals
                          || ':'
                          || i;
            end loop;

            l_sql := 'INSERT INTO '
                     || p_table_name
                     || ' ('
                     || l_cols
                     || ') '
                     || 'VALUES ('
                     || l_vals
                     || ') RETURNING '
                     || p_id_column
                     || ' INTO :id';

            execute immediate l_sql
                using p_values(1), p_values(2), p_values(3), p_values(4), p_values(5), out p_id_value;

        -- 🔹 UPDATE
        elsif upper(p_action) = 'UPDATE' then
            for i in 1..p_fields.count loop
                if i > 1 then
                    l_set_list := l_set_list || ', ';
                end if;
                l_set_list := l_set_list
                              || p_fields(i)
                              || ' = :'
                              || i;
            end loop;

            l_sql := 'UPDATE '
                     || p_table_name
                     || ' SET '
                     || l_set_list
                     || ' WHERE '
                     || p_id_column
                     || ' = :id';

            execute immediate l_sql
                using p_values(1), p_values(2), p_values(3), p_values(4), p_values(5), p_id_value;

        -- 🔹 DELETE
        elsif upper(p_action) = 'DELETE' then
            -- check if photo exists
            l_sql := 'SELECT '
                     || p_url_column
                     || ' FROM '
                     || p_table_name
                     || ' WHERE '
                     || p_id_column
                     || ' = :id';

            execute immediate l_sql
            into l_old_url
                using p_id_value;
            if l_old_url is not null then
                drive_crud_api.set_bucket('LayaliElqahera-ObjectStorage');
                drive_crud_api.delete_file(substr(l_old_url,
                                                  instr(l_old_url, '/') + 1));

            end if;

            l_sql := 'DELETE FROM '
                     || p_table_name
                     || ' WHERE '
                     || p_id_column
                     || ' = :id';
            execute immediate l_sql
                using p_id_value;
            return;
        end if;

        -- 🔹 Handle Photo (INSERT or UPDATE only)
        if p_page_item is not null then
            begin
                select
                    blob_content,
                    filename
                into
                    l_blob,
                    l_filename
                from
                    apex_application_temp_files
                where
                    name = p_page_item;

                l_extension := lower(nvl(
                    regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                    '.jpg'
                ));
                l_object_name := p_folder_name
                                 || '/'
                                 || p_id_value
                                 || l_extension;

                -- delete old if exists
                if upper(p_action) = 'UPDATE' then
                    begin
                        l_sql := 'SELECT '
                                 || p_url_column
                                 || ' FROM '
                                 || p_table_name
                                 || ' WHERE '
                                 || p_id_column
                                 || ' = :id';

                        execute immediate l_sql
                        into l_old_url
                            using p_id_value;
                        if l_old_url is not null then
                            drive_crud_api.set_bucket('LayaliElqahera-ObjectStorage');
                            drive_crud_api.delete_file(substr(l_old_url,
                                                              instr(l_old_url, '/') + 1));

                        end if;

                    exception
                        when no_data_found then
                            null;
                    end;
                end if;

                drive_crud_api.set_bucket('LayaliElqahera-ObjectStorage');
                drive_crud_api.upload_file(
                    p_parent_name => p_folder_name,
                    p_filename    => p_id_value || l_extension,
                    p_blob        => l_blob
                );

                l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                || drive_crud_api.create_par(
                    p_object_name  => l_object_name,
                    p_par_name     => lower(p_folder_name)
                                  || '-'
                                  || p_id_value
                                  || '-par',
                    p_time_expires => add_months(systimestamp, 12)
                );

                l_sql := 'UPDATE '
                         || p_table_name
                         || ' SET '
                         || p_url_column
                         || ' = :url, '
                         || p_date_column
                         || ' = SYSTIMESTAMP '
                         || 'WHERE '
                         || p_id_column
                         || ' = :id';

                execute immediate l_sql
                    using l_public_url, p_id_value;
            exception
                when no_data_found then
                    null;
            end;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20010, 'manage_record failed: ' || sqlerrm);
    end manage_record;

end photo_util;
/


-- sqlcl_snapshot {"hash":"6f1b1dd75195c328d6de11174c840fd914e441ec","type":"PACKAGE_BODY","name":"PHOTO_UTIL","schemaName":"WKSP_ELWAGHA50","sxml":""}