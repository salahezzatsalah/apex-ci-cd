-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463889495 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\whatsapp_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/whatsapp_pkg.sql:null:b2396be5dc44405ec234df16fd3dad0d453dc293:create

create or replace package whatsapp_pkg as

  /* Send OTP messages */
    function send_signup_otp (
        p_to  in varchar2,
        p_otp in varchar2
    ) return clob;

    function send_resetpass_otp (
        p_to  in varchar2,
        p_otp in varchar2
    ) return clob;

  /* Generate OTP (USER based) */
    procedure generate_otp (
        p_user_id  in varchar2,
        p_purpose  in varchar2,
        p_otp_id   out varchar2,
        p_otp_code out varchar2
    );

end whatsapp_pkg;
/

