create or replace package iam_admin_pkg as


  ----------------------------------------------------------
  -- IDENTITY
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
    );

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
        p_group_ids     in varchar2 default null,
        p_identity_id   out varchar2,
        p_user_id       out varchar2
    );
  ----------------------------------------------------------
  -- USERS
  ----------------------------------------------------------

    procedure create_user (
        p_username    in varchar2,
        p_password    in varchar2,
        p_email       in varchar2,
        p_phone       in varchar2,
        p_tenant_id   in varchar2,
        p_global_role in varchar2 default 'USER'
    );

    procedure update_user (
        p_user_id   in varchar2,
        p_email     in varchar2,
        p_phone     in varchar2,
        p_status    in varchar2,
        p_locked_yn in varchar2
    );

    procedure lock_user (
        p_user_id in varchar2
    );

    procedure unlock_user (
        p_user_id in varchar2
    );

  ----------------------------------------------------------
  -- GROUPS
  ----------------------------------------------------------

    procedure create_group (
        p_group_code  in varchar2,
        p_group_name  in varchar2,
        p_description in varchar2
    );

    procedure deactivate_group (
        p_group_id in varchar2
    );

  ----------------------------------------------------------
  -- GROUP ASSIGNMENT
  ----------------------------------------------------------

    procedure assign_user_to_group (
        p_user_id       in varchar2,
        p_group_ids     in varchar2,
        p_role_in_group in varchar2 default 'USER'
    );

    procedure remove_user_from_group (
        p_user_id  in varchar2,
        p_group_id in varchar2
    );

    procedure update_group_role (
        p_user_id       in varchar2,
        p_group_id      in varchar2,
        p_role_in_group in varchar2
    );

----------------------------------------------------------
-- RESET PASSWORD (WITH CONFIRMATION)
----------------------------------------------------------
    procedure reset_password (
        p_user_id          in varchar2,
        p_new_password     in varchar2,
        p_confirm_password in varchar2
    );

    procedure update_user_group_assignments (
        p_user_id       in varchar2,
        p_group_ids     in varchar2,   -- colon separated list from APEX
        p_role_in_group in varchar2 default 'USER'
    );

end iam_admin_pkg;
/


-- sqlcl_snapshot {"hash":"a4d3dd093f228d8f66eb20818a5a0fbe4e995f81","type":"PACKAGE_SPEC","name":"IAM_ADMIN_PKG","schemaName":"DEV_SCHEMA","sxml":""}