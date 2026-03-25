-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463858616 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\iam_admin_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/iam_admin_pkg.sql:null:00c262bcfee4e4ae9b98154b99003b0214a2a114:create

create or replace package body iam_admin_pkg as

----------------------------------------------------------
-- CREATE IDENTITY
----------------------------------------------------------
    procedure create_identity (
        p_tenant_id     in varchar2,
        p_identity_type in varchar2,
        p_first_name    in varchar2,
        p_last_name     in varchar2,
        p_national_id   in varchar2,
        p_passport_no   in varchar2,
        p_email         in varchar2,
        p_phone         in varchar2,
        p_dob           in date,
        p_gender        in varchar2,
        p_identity_id   out varchar2
    ) is
        v_full_name varchar2(500);
    begin

    -- Auto Build Full Name
        v_full_name := regexp_replace(
            trim(nvl(p_first_name, '')
                 || ' ' || nvl(p_last_name, '')),
            '\s+',
            ' '
        );

    -- Create Party
        insert into iam_parties (
            tenant_id,
            party_type,
            status,
            created
        ) values ( p_tenant_id,
                   'PERSON',
                   'ACTIVE',
                   systimestamp ) returning party_id into p_identity_id;

    -- Create Identity Details
        insert into iam_identities (
            identity_id,
            tenant_id,
            identity_type,
            first_name,
            last_name,
            full_name,
            national_id,
            passport_no,
            email,
            phone_number,
            date_of_birth,
            gender,
            status,
            is_active_yn,
            created
        ) values ( p_identity_id,
                   p_tenant_id,
                   p_identity_type,
                   p_first_name,
                   p_last_name,
                   v_full_name,
                   p_national_id,
                   p_passport_no,
                   p_email,
                   p_phone,
                   p_dob,
                   p_gender,
                   'ACTIVE',
                   'Y',
                   systimestamp );

    end create_identity;

----------------------------------------------------------
-- CREATE USER
----------------------------------------------------------
    procedure create_user (
        p_username    in varchar2,
        p_password    in varchar2,
        p_email       in varchar2,
        p_phone       in varchar2,
        p_tenant_id   in varchar2,
        p_global_role in varchar2
    ) is
    begin
        insert into iam_users (
            tenant_id,
            username,
            password_hash,
            email,
            phone_number,
            global_role,
            status,
            account_locked_yn
        ) values ( p_tenant_id,
                   upper(p_username),
                   security_pkg.get_hashing(p_password),
                   p_email,
                   p_phone,
                   nvl(p_global_role, 'USER'),
                   'ACTIVE',
                   'N' );

    end create_user;

----------------------------------------------------------
-- QUICK CREATE USER (APEX Select Many Version)
----------------------------------------------------------
    procedure create_user_quick (
        p_tenant_id     in varchar2,
        p_first_name    in varchar2,
        p_last_name     in varchar2,
        p_username      in varchar2,
        p_password      in varchar2,
        p_email         in varchar2 default null,
        p_phone         in varchar2 default null,
        p_global_role   in varchar2 default 'USER',
        p_identity_type in varchar2 default 'EMPLOYEE',
        p_group_ids     in varchar2 default null,  -- colon separated
        p_identity_id   out varchar2,
        p_user_id       out varchar2
    ) is
        v_email  varchar2(255);
        v_groups apex_t_varchar2;
    begin

    -- Derive email if not provided
        v_email := lower(nvl(p_email, p_username));

    ------------------------------------------------------
    -- 1️⃣ Create Identity
    ------------------------------------------------------
        create_identity(
            p_tenant_id     => p_tenant_id,
            p_identity_type => p_identity_type,
            p_first_name    => p_first_name,
            p_last_name     => p_last_name,
            p_national_id   => null,
            p_passport_no   => null,
            p_email         => v_email,
            p_phone         => p_phone,
            p_dob           => null,
            p_gender        => null,
            p_identity_id   => p_identity_id
        );

    ------------------------------------------------------
    -- 2️⃣ Create User
    ------------------------------------------------------
        insert into iam_users (
            tenant_id,
            identity_id,
            username,
            password_hash,
            email,
            phone_number,
            global_role,
            status,
            account_locked_yn,
            created
        ) values ( p_tenant_id,
                   p_identity_id,
                   upper(p_username),
                   security_pkg.get_hashing(p_password),
                   v_email,
                   p_phone,
                   nvl(p_global_role, 'USER'),
                   'ACTIVE',
                   'N',
                   systimestamp ) returning user_id into p_user_id;

    ------------------------------------------------------
    -- 3️⃣ Assign Groups (Colon-Separated)
    ------------------------------------------------------
        if p_group_ids is not null then
            v_groups := apex_string.split(p_group_ids, ':');
            for i in 1..v_groups.count loop
                assign_user_to_group(
                    p_user_id       => p_user_id,
                    p_group_ids     => v_groups(i),
                    p_role_in_group => 'USER'
                );
            end loop;

        end if;

    end create_user_quick;

----------------------------------------------------------
-- UPDATE USER
----------------------------------------------------------
    procedure update_user (
        p_user_id   in varchar2,
        p_email     in varchar2,
        p_phone     in varchar2,
        p_status    in varchar2,
        p_locked_yn in varchar2
    ) is
    begin
        update iam_users
        set
            email = p_email,
            phone_number = p_phone,
            status = p_status,
            account_locked_yn = p_locked_yn,
            updated = systimestamp
        where
            user_id = p_user_id;

    end update_user;

----------------------------------------------------------
-- LOCK / UNLOCK
----------------------------------------------------------
    procedure lock_user (
        p_user_id in varchar2
    ) is
    begin
        update iam_users
        set
            account_locked_yn = 'Y'
        where
            user_id = p_user_id;

    end;

    procedure unlock_user (
        p_user_id in varchar2
    ) is
    begin
        update iam_users
        set
            account_locked_yn = 'N'
        where
            user_id = p_user_id;

    end;

----------------------------------------------------------
-- CREATE GROUP
----------------------------------------------------------
    procedure create_group (
        p_group_code  in varchar2,
        p_group_name  in varchar2,
        p_description in varchar2
    ) is
    begin
        insert into iam_security_groups (
            group_code,
            group_name,
            description,
            is_active_yn
        ) values ( upper(p_group_code),
                   p_group_name,
                   p_description,
                   'Y' );

    end create_group;

----------------------------------------------------------
-- DEACTIVATE GROUP
----------------------------------------------------------
    procedure deactivate_group (
        p_group_id in varchar2
    ) is
    begin
        update iam_security_groups
        set
            is_active_yn = 'N'
        where
            group_id = p_group_id;

    end;

----------------------------------------------------------
-- ASSIGN USER TO GROUP
----------------------------------------------------------

    procedure assign_user_to_group (
        p_user_id       in varchar2,
        p_group_ids     in varchar2,   -- colon separated list
        p_role_in_group in varchar2
    ) is
        l_existing_count number;
        l_assigned_by    varchar2(100);
        v_groups         apex_t_varchar2;
    begin

    /* =====================================================
       Get session user (APEX)
       ===================================================== */
        l_assigned_by := nvl(
            v('APP_USER_ID'),
            'SYSTEM'
        );

    /* =====================================================
       Validate user exists
       ===================================================== */
        select
            count(*)
        into l_existing_count
        from
            iam_users
        where
            user_id = p_user_id;

        if l_existing_count = 0 then
            raise_application_error(-20020, 'User not found.');
        end if;

    /* =====================================================
       Split Groups
       ===================================================== */
        v_groups := apex_string.split(p_group_ids, ':');

    /* =====================================================
       Loop Through Groups
       ===================================================== */
        for i in 1..v_groups.count loop

        /* Validate group exists */
            select
                count(*)
            into l_existing_count
            from
                iam_security_groups
            where
                group_id = v_groups(i);

            if l_existing_count = 0 then
                raise_application_error(-20021,
                                        'Security group not found: ' || v_groups(i));
            end if;

        /* Check if already assigned */
            select
                count(*)
            into l_existing_count
            from
                iam_user_security_groups
            where
                    user_id = p_user_id
                and group_id = v_groups(i);

            if l_existing_count > 0 then

            /* Reactivate existing */
                update iam_user_security_groups
                set
                    is_active_yn = 'Y',
                    role_in_group = nvl(p_role_in_group, 'USER'),
                    assigned_by = l_assigned_by
                where
                        user_id = p_user_id
                    and group_id = v_groups(i);

            else

            /* Fresh insert */
                insert into iam_user_security_groups (
                    user_id,
                    group_id,
                    role_in_group,
                    is_active_yn,
                    assigned_by
                ) values ( p_user_id,
                           v_groups(i),
                           nvl(p_role_in_group, 'USER'),
                           'Y',
                           l_assigned_by );

            end if;

        end loop;

    end assign_user_to_group;

----------------------------------------------------------
-- REMOVE USER FROM GROUP
----------------------------------------------------------
    procedure remove_user_from_group (
        p_user_id  in varchar2,
        p_group_id in varchar2
    ) is
    begin
        delete from iam_user_security_groups
        where
                user_id = p_user_id
            and group_id = p_group_id;

    end remove_user_from_group;

----------------------------------------------------------
-- UPDATE ROLE IN GROUP
----------------------------------------------------------
    procedure update_group_role (
        p_user_id       in varchar2,
        p_group_id      in varchar2,
        p_role_in_group in varchar2
    ) is
    begin
        update iam_user_security_groups
        set
            role_in_group = p_role_in_group
        where
                user_id = p_user_id
            and group_id = p_group_id;

    end update_group_role;

----------------------------------------------------------
-- RESET PASSWORD (WITH CONFIRMATION)
----------------------------------------------------------
    procedure reset_password (
        p_user_id          in varchar2,
        p_new_password     in varchar2,
        p_confirm_password in varchar2
    ) is
    begin

    ------------------------------------------------------
    -- Validate password confirmation
    ------------------------------------------------------
        if p_new_password is null
           or p_confirm_password is null then
            raise_application_error(-20030, 'Password and confirmation password are required.');
        end if;

        if p_new_password <> p_confirm_password then
            raise_application_error(-20031, 'Passwords do not match.');
        end if;

    ------------------------------------------------------
    -- Update password
    ------------------------------------------------------
        update iam_users
        set
            password_hash = security_pkg.get_hashing(p_new_password),
            updated = systimestamp
        where
            user_id = p_user_id;

    ------------------------------------------------------
    -- Ensure user exists
    ------------------------------------------------------
        if sql%rowcount = 0 then
            raise_application_error(-20032, 'User not found.');
        end if;
    end reset_password;

    procedure update_user_group_assignments (
        p_user_id       in varchar2,
        p_group_ids     in varchar2,   -- colon separated list from APEX
        p_role_in_group in varchar2 default 'USER'
    ) is
        l_assigned_by varchar2(100);
        v_groups      apex_t_varchar2;
    begin

    ------------------------------------------------------
    -- Get session user
    ------------------------------------------------------
        l_assigned_by := nvl(
            v('APP_USER_ID'),
            'SYSTEM'
        );

    ------------------------------------------------------
    -- Convert colon string to array
    ------------------------------------------------------
        if p_group_ids is not null then
            v_groups := apex_string.split(p_group_ids, ':');
        end if;

    ------------------------------------------------------
    -- 1️⃣ Deactivate groups removed by the user
    ------------------------------------------------------
        update iam_user_security_groups
        set
            is_active_yn = 'N'
        where
                user_id = p_user_id
            and group_id not in (
                select
                    column_value
                from
                    table ( v_groups )
            );

    ------------------------------------------------------
    -- 2️⃣ Insert or Reactivate selected groups
    ------------------------------------------------------
        if p_group_ids is not null then
            for i in 1..v_groups.count loop
                merge into iam_user_security_groups tgt
                using (
                    select
                        p_user_id   as user_id,
                        v_groups(i) as group_id
                    from
                        dual
                ) src on ( tgt.user_id = src.user_id
                           and tgt.group_id = src.group_id )
                when matched then update
                set tgt.is_active_yn = 'Y',
                    tgt.role_in_group = nvl(p_role_in_group, 'USER'),
                    tgt.assigned_by = l_assigned_by
                when not matched then
                insert (
                    user_id,
                    group_id,
                    role_in_group,
                    is_active_yn,
                    assigned_by )
                values
                    ( src.user_id,
                      src.group_id,
                      nvl(p_role_in_group, 'USER'),
                      'Y',
                      l_assigned_by );

            end loop;
        end if;

    end update_user_group_assignments;

end iam_admin_pkg;
/

