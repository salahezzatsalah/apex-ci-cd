create or replace package body security_pkg as

--------------------------------------------------------------
-- Same old hashing logic (unchanged)
--------------------------------------------------------------
    function get_hashing (
        p_text in varchar2
    ) return raw is
        v_org_test  raw(1000) := utl_raw.cast_to_raw(p_text);
        v_hash_text raw(1000);
    begin
        v_hash_text := sys.dbms_crypto.hash(
            src => v_org_test,
            typ => sys.dbms_crypto.hash_sh256
        );

        return v_hash_text;
    end get_hashing;

--------------------------------------------------------------
-- HEX helper (used for inserts / admin resets)
--------------------------------------------------------------
    function hash_password (
        p_password in varchar2
    ) return varchar2 is
        l_hash_raw raw(200);
    begin
        l_hash_raw := dbms_crypto.hash(
            utl_i18n.string_to_raw(p_password, 'AL32UTF8'),
            dbms_crypto.hash_sh256
        );

        return lower(rawtohex(l_hash_raw));
    end hash_password;

--------------------------------------------------------------
-- Authentication
--------------------------------------------------------------
    function user_is_authenticated (
        p_username in varchar2,
        p_password in varchar2
    ) return boolean is

        l_user_id         iam_users.user_id%type;
        l_password_raw    raw(200);
        l_stored_password raw(200);
        l_status          iam_users.status%type;
        l_locked          iam_users.account_locked_yn%type;
        l_global_role     iam_users.global_role%type;
        l_tenant_id       iam_users.tenant_id%type;
        l_user_type       varchar2(30);
    begin
        select
            user_id,
            password_hash,
            status,
            nvl(account_locked_yn, 'Y'),
            global_role,
            tenant_id
        into
            l_user_id,
            l_stored_password,
            l_status,
            l_locked,
            l_global_role,
            l_tenant_id
        from
            iam_users
        where
                upper(username) = upper(p_username)
            and rownum = 1;

        if l_locked = 'Y' then
            apex_util.set_authentication_result(2);
            raise_application_error(-20001, 'Your account is locked.');
        end if;

        if nvl(l_status, 'INACTIVE') <> 'ACTIVE' then
            apex_util.set_authentication_result(2);
            raise_application_error(-20002, 'Your account is not active.');
        end if;

        l_password_raw := get_hashing(p_text => p_password);
        if l_password_raw = l_stored_password then

        -- Determine user type from groups
            begin
                select
                    g.group_code
                into l_user_type
                from
                         iam_user_security_groups ug
                    join iam_security_groups g on g.group_id = ug.group_id
                where
                        ug.user_id = l_user_id
                    and ug.is_active_yn = 'Y'
                    and g.is_active_yn = 'Y'
                    and g.group_code in ( 'EMPLOYEES', 'SUPPLIERS', 'DRIVERS' )
                    and rownum = 1;

            exception
                when no_data_found then
                    l_user_type := 'USER';
            end;

            apex_util.set_authentication_result(0);
            apex_util.set_session_state('APP_USER_ID', l_user_id);
            apex_util.set_session_state('TENANT_ID', l_tenant_id);
            apex_util.set_session_state('GLOBAL_ROLE', l_global_role);
            apex_util.set_session_state('USER_TYPE', l_user_type);
            return true;
        else
            apex_util.set_authentication_result(4);
            return false;
        end if;

    exception
        when no_data_found then
            apex_util.set_authentication_result(1);
            return false;
        when others then
            apex_util.set_authentication_result(7);
            apex_util.set_custom_auth_status(sqlerrm);
            return false;
    end user_is_authenticated;

--------------------------------------------------------------
-- Global role check
--------------------------------------------------------------
    function is_superadmin return boolean is
    begin
        return nvl(
            v('GLOBAL_ROLE'),
            'USER'
        ) = 'SUPERADMIN';
    end is_superadmin;

--------------------------------------------------------------
-- Group membership check
--------------------------------------------------------------
    function in_group (
        p_group_code in varchar2
    ) return boolean is
        l_dummy number;
    begin
        if is_superadmin then
            return true;
        end if;
        select
            1
        into l_dummy
        from
                 iam_user_security_groups ug
            join iam_security_groups g on g.group_id = ug.group_id
        where
                ug.user_id = v('APP_USER_ID')
            and ug.is_active_yn = 'Y'
            and g.is_active_yn = 'Y'
            and upper(g.group_code) = upper(p_group_code);

        return true;
    exception
        when no_data_found then
            return false;
    end in_group;

--------------------------------------------------------------
-- Role inside group
--------------------------------------------------------------
    function role_in_group (
        p_group_code in varchar2
    ) return varchar2 is
        l_role iam_user_security_groups.role_in_group%type;
    begin
        if is_superadmin then
            return 'ADMIN';
        end if;
        select
            ug.role_in_group
        into l_role
        from
                 iam_user_security_groups ug
            join iam_security_groups g on g.group_id = ug.group_id
        where
                ug.user_id = v('APP_USER_ID')
            and ug.is_active_yn = 'Y'
            and g.is_active_yn = 'Y'
            and upper(g.group_code) = upper(p_group_code);

        return l_role;
    exception
        when no_data_found then
            return null;
    end role_in_group;

end security_pkg;
/


-- sqlcl_snapshot {"hash":"e340a20305045cc32933e83541748f1856fb8f56","type":"PACKAGE_BODY","name":"SECURITY_PKG","schemaName":"DEV_SCHEMA","sxml":""}