-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463887139 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\security_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/security_pkg.sql:null:cbf0edad67d746cc03707590762a1341d37294bf:create

create or replace package security_pkg as

  ----------------------------------------------------------
  -- Hashing (RAW version - same as old system)
  ----------------------------------------------------------
    function get_hashing (
        p_text in varchar2
    ) return raw;

  ----------------------------------------------------------
  -- Hash password (HEX string helper)
  ----------------------------------------------------------
    function hash_password (
        p_password in varchar2
    ) return varchar2;

  ----------------------------------------------------------
  -- Authentication
  ----------------------------------------------------------
    function user_is_authenticated (
        p_username in varchar2,
        p_password in varchar2
    ) return boolean;

  ----------------------------------------------------------
  -- Authorization helpers
  ----------------------------------------------------------
    function is_superadmin return boolean;

    function in_group (
        p_group_code in varchar2
    ) return boolean;

    function role_in_group (
        p_group_code in varchar2
    ) return varchar2;

end security_pkg;
/

