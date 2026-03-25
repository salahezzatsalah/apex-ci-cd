-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463853940 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\clients_auth_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/clients_auth_pkg.sql:null:f1de8c793c4cf68247342b847d9acfd49084d4bf:create

create or replace package body clients_auth_pkg as

    g_salt       constant varchar2(50) := 'ELWAGHA_2025!';
    g_jwt_secret constant varchar2(200) := 'CHANGE_ME_TO_A_STRONG_SECRET_256BIT';

  /* ===============================
     Helpers
     =============================== */

    function hash_password (
        p_password varchar2
    ) return varchar2 is
        l_raw raw(2000);
    begin
        l_raw := dbms_crypto.hash(
            utl_raw.cast_to_raw(p_password || g_salt),
            dbms_crypto.hash_sh256
        );

        return lower(rawtohex(l_raw));
    end;

    function normalize_phone (
        p_country_code in varchar2,
        p_phone_number in varchar2
    ) return varchar2 is

        v_cc varchar2(10) := trim(p_country_code);
        v_ph varchar2(50) := regexp_replace(p_phone_number, '[^0-9]', '');
    begin
        if
            v_cc is not null
            and substr(v_cc, 1, 1) != '+'
        then
            v_cc := '+' || v_cc;
        end if;

        v_ph := regexp_replace(v_ph, '^0+', '');
        return v_cc || v_ph;
    end;

    function whatsapp_to_number (
        p_phone varchar2
    ) return varchar2 is
    begin
        return regexp_replace(p_phone, '^\+', '');
    end;



  /* ===============================
     JWT SECTION (no APEX_JWT)
     =============================== */

    function unix_epoch_seconds (
        p_ts timestamp with time zone
    ) return number is
        l_utc timestamp with time zone := p_ts at time zone 'UTC';
    begin
        return ( cast ( l_utc as date ) - date '1970-01-01' ) * 86400;
    end;

    function b64url_encode (
        p_raw raw
    ) return varchar2 is
        l_b64 varchar2(32767);
    begin
        l_b64 := utl_raw.cast_to_varchar2(utl_encode.base64_encode(p_raw));
        l_b64 := replace(l_b64,
                         chr(10),
                         '');
        l_b64 := replace(l_b64,
                         chr(13),
                         '');
        l_b64 := replace(l_b64, '+', '-');
        l_b64 := replace(l_b64, '/', '_');
        l_b64 := replace(l_b64, '=', '');
        return l_b64;
    end;

    function hmac_sha256_b64url (
        p_data   varchar2,
        p_secret varchar2
    ) return varchar2 is
        l_mac raw(32767);
    begin
        l_mac := dbms_crypto.mac(
            src => utl_raw.cast_to_raw(p_data),
            typ => dbms_crypto.hmac_sh256,
            key => utl_raw.cast_to_raw(p_secret)
        );

        return b64url_encode(l_mac);
    end;

    function make_jwt (
        p_payload_json in clob
    ) return varchar2 is

        l_header_json varchar2(200) := '{"alg":"HS256","typ":"JWT"}';
        l_header_b64  varchar2(4000);
        l_payload_b64 varchar2(4000);
        l_sign_input  varchar2(32767);
        l_sig_b64     varchar2(4000);
    begin
        l_header_b64 := b64url_encode(utl_raw.cast_to_raw(l_header_json));
        l_payload_b64 := b64url_encode(utl_raw.cast_to_raw(dbms_lob.substr(p_payload_json, 32767, 1)));

        l_sign_input := l_header_b64
                        || '.'
                        || l_payload_b64;
        l_sig_b64 := hmac_sha256_b64url(l_sign_input, g_jwt_secret);
        return l_sign_input
               || '.'
               || l_sig_b64;
    end;

    function generate_access_jwt (
        p_user_id   in varchar2,
        p_client_id in varchar2,
        p_username  in varchar2,
        p_user_type in varchar2 default 'PHONE',
        p_minutes   in number default 60
    ) return varchar2 is

        l_now     timestamp with time zone := systimestamp;
        l_exp_ts  timestamp with time zone := l_now + numtodsinterval(p_minutes * 60, 'SECOND');
        l_iat     number := unix_epoch_seconds(l_now);
        l_exp     number := unix_epoch_seconds(l_exp_ts);
        l_payload clob;
    begin
        l_payload := '{'
                     || '"sub":"'
                     || p_user_id
                     || '",'
                     || '"cid":"'
                     || p_client_id
                     || '",'
                     || '"usr":"'
                     || replace(p_username, '"', '')
                     || '",'
                     || '"typ":"'
                     || p_user_type
                     || '",'
                     || '"token_type":"access",'
                     || '"iat":'
                     || to_char(l_iat)
                     || ','
                     || '"exp":'
                     || to_char(l_exp)
                     || '}';

        return make_jwt(l_payload);
    end;

    function generate_refresh_jwt (
        p_user_id   in varchar2,
        p_client_id in varchar2,
        p_username  in varchar2,
        p_user_type in varchar2 default 'PHONE',
        p_days      in number default 30
    ) return varchar2 is

        l_now     timestamp with time zone := systimestamp;
        l_exp_ts  timestamp with time zone := l_now + numtodsinterval(p_days * 86400, 'SECOND');
        l_iat     number := unix_epoch_seconds(l_now);
        l_exp     number := unix_epoch_seconds(l_exp_ts);
        l_payload clob;
    begin
        l_payload := '{'
                     || '"sub":"'
                     || p_user_id
                     || '",'
                     || '"cid":"'
                     || p_client_id
                     || '",'
                     || '"usr":"'
                     || replace(p_username, '"', '')
                     || '",'
                     || '"typ":"'
                     || p_user_type
                     || '",'
                     || '"token_type":"refresh",'
                     || '"iat":'
                     || to_char(l_iat)
                     || ','
                     || '"exp":'
                     || to_char(l_exp)
                     || '}';

        return make_jwt(l_payload);
    end;

  /* ===============================
     Registration
     =============================== */
    procedure register_user_by_phone (
        p_full_name    in varchar2,
        p_country_code in varchar2,
        p_phone_number in varchar2,
        p_password     in varchar2,
        p_source       in varchar2,
        p_user_id      out varchar2,
        p_client_id    out varchar2,
        p_otp_id       out varchar2
    ) is

        v_phone             varchar2(150);
        v_otp_code          varchar2(10);
        v_wa_to             varchar2(150);
        l_send_resp         clob;
        l_status            customer_users.status%type;
        l_verified          customer_users.verified%type;
        l_existing_otp_id   otp_logs.otp_id%type;
        l_existing_otp_code otp_logs.otp_code%type;
        l_dummy             number;
    begin
        if p_phone_number is null
           or p_password is null then
            raise_application_error(-20001, 'Phone and password are required');
        end if;

        v_phone := normalize_phone(p_country_code, p_phone_number);

  /* 1) Check if user exists */
        begin
            select
                user_id,
                status,
                verified,
                client_id
            into
                p_user_id,
                l_status,
                l_verified,
                p_client_id
            from
                customer_users
            where
                lower(username) = lower(v_phone);

            if
                l_status = 'ACTIVE'
                and l_verified = 'Y'
            then
                raise_application_error(-20010, 'Phone number already registered');
            end if;

    /* ✅ NEW: Ensure CLIENT exists even if user already existed */
            begin
                select
                    1
                into l_dummy
                from
                    clients
                where
                    client_id = p_client_id;

            exception
                when no_data_found then
        -- create minimal client record if missing
                    insert into clients (
                        client_id,
                        full_name,
                        status,
                        source_channel,
                        created_at,
                        created_by
                    ) values ( p_client_id,
                               nvl(p_full_name, 'Unknown'),
                               'LEAD',
                               nvl(p_source, 'APP'),
                               systimestamp,
                               'REPAIR_FROM_REGISTER' );

        -- ensure phone contact exists
                    begin
                        select
                            1
                        into l_dummy
                        from
                            client_contacts
                        where
                                client_id = p_client_id
                            and contact_type = 'PHONE'
                            and contact_value = v_phone;

                    exception
                        when no_data_found then
                            insert into client_contacts (
                                client_id,
                                contact_type,
                                contact_value,
                                is_primary,
                                verified
                            ) values ( p_client_id,
                                       'PHONE',
                                       v_phone,
                                       'Y',
                                       'N' );

                    end;

                    insert into client_events (
                        client_id,
                        event_type,
                        event_source,
                        event_date,
                        event_data_json,
                        created_by
                    ) values ( p_client_id,
                               'CLIENT_REPAIRED',
                               'REGISTER_USER',
                               sysdate,
                               '{"reason":"client_id exists in CUSTOMER_USERS but missing in CLIENTS"}',
                               'REPAIR_FROM_REGISTER' );

            end;

        exception
            when no_data_found then
      /* user not exists => normal flow */
                p_client_id := get_or_create_client_by_phone(
                    p_phone      => v_phone,
                    p_full_name  => p_full_name,
                    p_source     => p_source,
                    p_created_by => 'WEB_REGISTER'
                );

                insert into customer_users (
                    user_id,
                    client_id,
                    username,
                    user_type,
                    password_hash,
                    status,
                    verified,
                    created_at,
                    created_by
                ) values ( rawtohex(sys_guid()),
                           p_client_id,
                           v_phone,
                           'PHONE',
                           hash_password(p_password),
                           'PENDING',
                           'N',
                           systimestamp,
                           'WEB_REGISTER' ) returning user_id into p_user_id;

        end;

  /* 2) Reuse valid OTP if exists */
        begin
            select
                otp_id,
                otp_code
            into
                l_existing_otp_id,
                l_existing_otp_code
            from
                otp_logs
            where
                    user_id = p_user_id
                and purpose = 'SIGNUP'
                and nvl(is_used, 'N') = 'N'
                and expires_at > systimestamp
            order by
                created_at desc
            fetch first 1 row only;

            p_otp_id := l_existing_otp_id;
            v_otp_code := l_existing_otp_code;
        exception
            when no_data_found then
                whatsapp_pkg.generate_otp(
                    p_user_id  => p_user_id,
                    p_purpose  => 'SIGNUP',
                    p_otp_id   => p_otp_id,
                    p_otp_code => v_otp_code
                );
        end;

  /* 3) Send OTP */
        v_wa_to := whatsapp_to_number(v_phone);
        l_send_resp := whatsapp_pkg.send_signup_otp(
            p_to  => v_wa_to,
            p_otp => v_otp_code
        );

  /* 4) Log event */
        insert into client_events (
            client_id,
            event_type,
            event_source,
            related_entity,
            related_id,
            event_date,
            event_data_json,
            created_by
        ) values ( p_client_id,
                   'OTP_SENT',
                   'WHATSAPP',
                   'CUSTOMER_USERS',
                   p_user_id,
                   sysdate,
                   '{"purpose":"SIGNUP"}',
                   'WEB_REGISTER' );

    end register_user_by_phone;

  /* ===============================
     Verify OTP
     =============================== */

    function verify_otp (
        p_user_id  in varchar2,
        p_otp_code in varchar2,
        p_purpose  in varchar2
    ) return boolean is
        v_cnt number;
    begin
        select
            count(*)
        into v_cnt
        from
            otp_logs
        where
                user_id = p_user_id
            and otp_code = p_otp_code
            and purpose = p_purpose
            and nvl(is_used, 'N') = 'N'
            and ( expires_at is null
                  or expires_at >= systimestamp );

        if v_cnt = 0 then
            return false;
        end if;
        update otp_logs
        set
            is_used = 'Y'
        where
                user_id = p_user_id
            and otp_code = p_otp_code
            and purpose = p_purpose
            and nvl(is_used, 'N') = 'N';

        update customer_users
        set
            status = 'ACTIVE',
            verified = 'Y',
            updated_at = systimestamp,
            updated_by = 'OTP_VERIFY'
        where
            user_id = p_user_id;

        return true;
    end;

  /* ===============================
     Login (returns USER_ID or NULL)
     =============================== */

    function login_with_token (
        p_country_code in varchar2,
        p_phone_number in varchar2,
        p_password     in varchar2
    ) return varchar2 is
        v_phone   varchar2(150);
        v_user_id customer_users.user_id%type;
    begin
        v_phone := normalize_phone(p_country_code, p_phone_number);
        select
            user_id
        into v_user_id
        from
            customer_users
        where
                lower(username) = lower(v_phone)
            and password_hash = hash_password(p_password)
            and status = 'ACTIVE'
            and verified = 'Y';

        update customer_users
        set
            last_login_at = systimestamp
        where
            user_id = v_user_id;

        return v_user_id;
    exception
        when no_data_found then
            return null;
    end;

  /* ===============================
     Resend OTP
     =============================== */

    procedure resend_otp (
        p_user_id in varchar2,
        p_purpose in varchar2,
        p_otp_id  out varchar2
    ) is

        v_phone     varchar2(150);
        v_otp_code  varchar2(10);
        v_wa_to     varchar2(150);
        l_send_resp clob;
    begin
        select
            username
        into v_phone
        from
            customer_users
        where
            user_id = p_user_id;

        whatsapp_pkg.generate_otp(
            p_user_id  => p_user_id,
            p_purpose  => p_purpose,
            p_otp_id   => p_otp_id,
            p_otp_code => v_otp_code
        );

        v_wa_to := whatsapp_to_number(v_phone);
        if p_purpose = 'RESET_PASS' then
            l_send_resp := whatsapp_pkg.send_resetpass_otp(v_wa_to, v_otp_code);
        else
            l_send_resp := whatsapp_pkg.send_signup_otp(v_wa_to, v_otp_code);
        end if;

    end;

    procedure forgot_password (
        p_country_code in varchar2,
        p_phone_number in varchar2,
        p_user_id      out varchar2,
        p_otp_id       out varchar2
    ) is

        v_phone     varchar2(150);
        v_otp_code  varchar2(10);
        v_wa_to     varchar2(150);
        l_send_resp clob;
    begin
        if p_phone_number is null then
            raise_application_error(-20030, 'Phone is required');
        end if;
        v_phone := normalize_phone(p_country_code, p_phone_number);

  -- لازم يكون اليوزر موجود
        begin
            select
                user_id
            into p_user_id
            from
                customer_users
            where
                lower(username) = lower(v_phone);

        exception
            when no_data_found then
      -- لأمان السيستم: ممكن ترجعي نفس الرسالة "لو الرقم موجود هنبعت OTP"
      -- لكن هنا هنطلع خطأ واضح عشان الديباج
                raise_application_error(-20031, 'User not found');
        end;

  -- توليد OTP للـ RESET_PASS
        whatsapp_pkg.generate_otp(
            p_user_id  => p_user_id,
            p_purpose  => 'RESET_PASS',
            p_otp_id   => p_otp_id,
            p_otp_code => v_otp_code
        );

        v_wa_to := whatsapp_to_number(v_phone);
        l_send_resp := whatsapp_pkg.send_resetpass_otp(v_wa_to, v_otp_code);
    end forgot_password;

  /* ===============================
     Reset password
     =============================== */

    procedure reset_password (
        p_user_id      in varchar2,
        p_otp_code     in varchar2,
        p_new_password in varchar2
    ) is
        v_ok boolean;
    begin
        v_ok := verify_otp(p_user_id, p_otp_code, 'RESET_PASS');
        if not v_ok then
            raise_application_error(-20020, 'OTP غير صحيح أو منتهي');
        end if;
        update customer_users
        set
            password_hash = hash_password(p_new_password),
            updated_at = systimestamp,
            updated_by = 'RESET_PASS'
        where
            user_id = p_user_id;

    end;

  /* ===============================
     Issue tokens + save (Access + Refresh)
     =============================== */

    procedure issue_tokens_for_user (
        p_user_id       in varchar2,
        p_access_token  out varchar2,
        p_access_exp    out timestamp with time zone,
        p_refresh_token out varchar2,
        p_refresh_exp   out timestamp with time zone
    ) is

        l_client_id customer_users.client_id%type;
        l_username  customer_users.username%type;
        l_user_type customer_users.user_type%type;
    begin
        select
            client_id,
            username,
            user_type
        into
            l_client_id,
            l_username,
            l_user_type
        from
            customer_users
        where
            user_id = p_user_id;

        p_access_exp := systimestamp + interval '60' minute;
        p_refresh_exp := systimestamp + interval '30' day;
        p_access_token := generate_access_jwt(
            p_user_id   => p_user_id,
            p_client_id => l_client_id,
            p_username  => l_username,
            p_user_type => l_user_type,
            p_minutes   => 60
        );

        p_refresh_token := generate_refresh_jwt(
            p_user_id   => p_user_id,
            p_client_id => l_client_id,
            p_username  => l_username,
            p_user_type => l_user_type,
            p_days      => 30
        );

    -- One-session behavior:
        delete from customer_user_tokens
        where
            user_id = p_user_id;

        update customer_user_refresh_tokens
        set
            revoked_at = systimestamp
        where
                user_id = p_user_id
            and revoked_at is null;

        insert into customer_user_tokens (
            user_id,
            access_token,
            expires_at,
            created_by
        ) values ( p_user_id,
                   p_access_token,
                   p_access_exp,
                   'AUTH' );

        insert into customer_user_refresh_tokens (
            user_id,
            refresh_token,
            expires_at,
            created_by
        ) values ( p_user_id,
                   p_refresh_token,
                   p_refresh_exp,
                   'AUTH' );

    end;

  /* ===============================
     Refresh access token using refresh token from DB
     =============================== */

    function refresh_access_token (
        p_refresh_token in varchar2,
        p_access_token  out varchar2,
        p_access_exp    out timestamp with time zone
    ) return boolean is

        l_user_id   customer_user_refresh_tokens.user_id%type;
        l_client_id customer_users.client_id%type;
        l_username  customer_users.username%type;
        l_user_type customer_users.user_type%type;
    begin
        select
            user_id
        into l_user_id
        from
            customer_user_refresh_tokens
        where
                refresh_token = p_refresh_token
            and revoked_at is null
            and expires_at > systimestamp;

        select
            client_id,
            username,
            user_type
        into
            l_client_id,
            l_username,
            l_user_type
        from
            customer_users
        where
                user_id = l_user_id
            and status = 'ACTIVE'
            and verified = 'Y';

        p_access_exp := systimestamp + interval '60' minute;
        p_access_token := generate_access_jwt(
            p_user_id   => l_user_id,
            p_client_id => l_client_id,
            p_username  => l_username,
            p_user_type => l_user_type,
            p_minutes   => 60
        );

        delete from customer_user_tokens
        where
            user_id = l_user_id;

        insert into customer_user_tokens (
            user_id,
            access_token,
            expires_at,
            created_by
        ) values ( l_user_id,
                   p_access_token,
                   p_access_exp,
                   'REFRESH' );

        return true;
    exception
        when no_data_found then
            return false;
    end;

    /* ===============================
     Manual Client Creation (FAST)
     =============================== */
    procedure create_client_manual (
        p_full_name    in varchar2,
        p_phone        in varchar2,
        p_country_name in varchar2,
        p_created_by   in varchar2 default 'APEX_MANUAL',
        p_client_id    out varchar2
    ) is
        l_phone_norm       varchar2(50);
        l_phone_country_cd varchar2(5);
    begin
      /* =========================================
         1) Normalize phone (digits only)
         ========================================= */
        l_phone_norm := regexp_replace(p_phone, '[^0-9]', '');
        if l_phone_norm is null then
            raise_application_error(-20001, 'Phone number is required');
        end if;

      /* =========================================
         2) Infer phone country code (simple)
         ========================================= */
        l_phone_country_cd := substr(l_phone_norm, 1, 3);

      /* =========================================
         3) Get or create client
         (returns existing CLIENT_ID if found)
         ========================================= */
        p_client_id := get_or_create_client_by_phone(
            p_phone      => l_phone_norm,
            p_full_name  => p_full_name,
            p_source     => 'MANUAL_ENTRY',
            p_created_by => p_created_by
        );

      /* =========================================
         4) Update only missing fields
         ========================================= */
        update clients
        set
            full_name = nvl(full_name, p_full_name),
            country_name = nvl(country_name, p_country_name),
            updated_at = systimestamp,
            updated_by = p_created_by
        where
            client_id = p_client_id;

        commit;
    exception
        when others then
            rollback;
            raise;
    end create_client_manual;

end clients_auth_pkg;
/

