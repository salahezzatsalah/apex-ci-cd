-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463852981 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\client_profile_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/client_profile_pkg.sql:null:96b4c0e12f723bd0155e22a3a51cc55bf04d887b:create

create or replace package body client_profile_pkg as

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
    ) is

        l_payload_b64  varchar2(4000);
        l_payload_raw  raw(32767);
        l_payload_json clob;
        l_user_id      varchar2(32);
        l_client_id    varchar2(36);
        l_phone_norm   varchar2(150);
        l_ext          varchar2(10);
        l_object_name  varchar2(4000);
        l_par_url      varchar2(4000);
        l_size         number;

        function b64url_to_raw (
            p_str varchar2
        ) return raw is
            l_str varchar2(4000) := p_str;
        begin
            l_str := replace(l_str, '-', '+');
            l_str := replace(l_str, '_', '/');
            while mod(
                length(l_str),
                4
            ) != 0 loop
                l_str := l_str || '=';
            end loop;

            return utl_encode.base64_decode(utl_raw.cast_to_raw(l_str));
        end;

        function ts_str return varchar2 is
        begin
            return to_char(systimestamp, 'YYYYMMDDHH24MISSFF3');
        end;

    begin
        p_image_url := null;
        if p_token is null then
            raise_application_error(-20001, 'Missing token');
        end if;
        l_payload_b64 := regexp_substr(p_token, '^[^.]+\.(.+?)\.[^.]+$', 1, 1, null,
                                       1);
        if l_payload_b64 is null then
            raise_application_error(-20002, 'Invalid token format');
        end if;
        l_payload_raw := b64url_to_raw(l_payload_b64);
        l_payload_json := utl_raw.cast_to_varchar2(l_payload_raw);
        apex_json.parse(l_payload_json);
        l_user_id := apex_json.get_varchar2('sub');
        if l_user_id is null then
            l_user_id := to_char(apex_json.get_number('sub'));
        end if;

        if l_user_id is null then
            raise_application_error(-20003, 'Invalid token: sub not found');
        end if;
        select
            client_id
        into l_client_id
        from
            customer_users
        where
            user_id = l_user_id;

        if p_country_code is not null
           or p_phone_number is not null then
            l_phone_norm := clients_auth_pkg.normalize_phone(p_country_code,
                                                             nvl(p_phone_number, ''));
        end if;

        update clients
        set
            full_name = coalesce(p_full_name, full_name),
            nationality = coalesce(p_nationality, nationality),
            date_of_birth = coalesce(p_date_of_birth, date_of_birth),
            updated_at = systimestamp,
            updated_by = 'PROFILE_UPDATE'
        where
            client_id = l_client_id;

        if sql%rowcount = 0 then
            raise_application_error(-20004, 'Client not found for this user');
        end if;
        if
            l_phone_norm is not null
            and trim(l_phone_norm) is not null
        then
            update customer_users
            set
                username = l_phone_norm,
                updated_at = systimestamp,
                updated_by = 'PROFILE_UPDATE'
            where
                user_id = l_user_id;

        end if;

        if p_photo_blob is not null then
            if p_photo_mime_type is null then
                raise_application_error(-20010, 'photo_mime_type is required when photo is provided');
            end if;
            l_size := dbms_lob.getlength(p_photo_blob);
            if l_size > 10 * 1024 * 1024 then
                raise_application_error(-20011, 'Photo too large (max 10MB)');
            end if;

            case lower(trim(p_photo_mime_type))
                when 'image/jpeg' then
                    l_ext := '.jpg';
                when 'image/jpg' then
                    l_ext := '.jpg';
                when 'image/png' then
                    l_ext := '.png';
                when 'image/webp' then
                    l_ext := '.webp';
                when 'image/gif' then
                    l_ext := '.gif';
                else
                    raise_application_error(-20012, 'Unsupported image type');
            end case;

            l_object_name := 'PROFILE_IMAGES/'
                             || l_client_id
                             || '/profile_'
                             || ts_str
                             || l_ext;
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.upload_file(
                p_parent_name => 'PROFILE_IMAGES/' || l_client_id,
                p_filename    => 'profile_'
                              || ts_str
                              || l_ext,
                p_blob        => p_photo_blob
            );

            l_par_url := drive_crud_api.create_par(
                p_object_name  => l_object_name,
                p_par_name     => 'profile-'
                              || l_client_id
                              || '-par',
                p_time_expires => add_months(systimestamp, 12)
            );

            update clients
            set
                profile_image_url = l_par_url,
                updated_at = systimestamp,
                updated_by = 'PROFILE_PHOTO'
            where
                client_id = l_client_id;

            p_image_url := l_par_url;
        end if;

    end update_profile;

    procedure delete_user (
        p_token      in varchar2,
        p_debug_json out clob
    ) is

        l_payload_b64  varchar2(4000);
        l_payload_raw  raw(32767);
        l_payload_json clob;
        l_user_id      varchar2(32);
        l_client_id    varchar2(36);

        function b64url_to_raw (
            p_str varchar2
        ) return raw is
            l_str varchar2(4000) := p_str;
        begin
            l_str := replace(l_str, '-', '+');
            l_str := replace(l_str, '_', '/');
            while mod(
                length(l_str),
                4
            ) != 0 loop
                l_str := l_str || '=';
            end loop;

            return utl_encode.base64_decode(utl_raw.cast_to_raw(l_str));
        end;

    begin
        if p_token is null then
            p_debug_json := '{"success":false,"error":"Missing token"}';
            return;
        end if;

    -- 1️⃣ Extract JWT payload
        l_payload_b64 := regexp_substr(p_token, '^[^.]+\.(.+?)\.[^.]+$', 1, 1, null,
                                       1);
        if l_payload_b64 is null then
            p_debug_json := '{"success":false,"error":"Invalid token format"}';
            return;
        end if;
        l_payload_raw := b64url_to_raw(l_payload_b64);
        l_payload_json := utl_raw.cast_to_varchar2(l_payload_raw);
        apex_json.parse(l_payload_json);

    -- 2️⃣ user_id from sub
        l_user_id := apex_json.get_varchar2('sub');
        if l_user_id is null then
            l_user_id := to_char(apex_json.get_number('sub'));
        end if;

        if l_user_id is null then
            p_debug_json := '{"success":false,"error":"user_id not found in token"}';
            return;
        end if;

    -- 3️⃣ get client_id
        begin
            select
                client_id
            into l_client_id
            from
                customer_users
            where
                    user_id = l_user_id
                and status <> 'DELETED';

        exception
            when no_data_found then
                p_debug_json := '{"success":false,"error":"User not found or already deleted"}';
                return;
        end;

    -- 4️⃣ Soft delete CUSTOMER_USERS
        update customer_users
        set
            status = 'DELETED',
            verified = 'N',
            updated_at = systimestamp,
            updated_by = 'SELF_DELETE'
        where
            user_id = l_user_id;

    -- 5️⃣ Optional: mark client inactive (NOT delete)
        update clients
        set
            status = 'INACTIVE',
            updated_at = systimestamp,
            updated_by = 'SELF_DELETE'
        where
            client_id = l_client_id;

        commit;

    -- 6️⃣ Response
        apex_json.open_object;
        apex_json.write('success', true);
        apex_json.write('message', 'Account deleted successfully');
        apex_json.write('user_id', l_user_id);
        apex_json.write('client_id', l_client_id);
        apex_json.close_object;
        p_debug_json := apex_json.get_clob_output;
        apex_json.free_output;
    exception
        when others then
            rollback;
            p_debug_json := '{"success":false,"error":"'
                            || replace(sqlerrm, '"', '''')
                            || '"}';
    end delete_user;

end client_profile_pkg;
/

