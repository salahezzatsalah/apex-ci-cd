create or replace package body whatsapp_pkg as

  ------------------------------------------------------------------
  -- Credentials (from your .env)
  ------------------------------------------------------------------
    g_token    varchar2(4000) := 'EAAF4Y0n2ZBjgBQAV7ygi3CvDXsAvoNNMEzaYVG4AOakPmcDZCEmU5B6XZBAFjfMSTOZBaPPHQNcZBZBBCshqXP2xFPaB5kfdKDMOEJVxVt17CLtZCJFIB1ZBjhatvSRbHpmZBJVEP0s0ilmmZCnhd9bqKbJZBhzpvn15l2jDXJooaHoVEZCFtZC6z5sqSdmuOUsexF90RSOsNfRFbD20shn3Al2tmdlSj3Y6MeBpxec78'
    ;
    g_phone_id varchar2(50) := '239328819274977';

  /* =========================================================
     Internal helper: send request using Bearer token
     ========================================================= */
    function send_whatsapp_request (
        p_body in clob
    ) return clob is
        l_url      varchar2(4000);
        l_response clob;
        l_status   number;
    begin
        l_url := 'https://graph.facebook.com/v23.0/'
                 || g_phone_id
                 || '/messages';
        apex_web_service.g_request_headers.delete;
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';
        apex_web_service.g_request_headers(2).name := 'Authorization';
        apex_web_service.g_request_headers(2).value := 'Bearer ' || g_token;
        l_response := apex_web_service.make_rest_request(
            p_url         => l_url,
            p_http_method => 'POST',
            p_body        => p_body
        );

        l_status := apex_web_service.g_status_code;
        return '{"status_code":'
               || l_status
               || ',"response":'
               || nvl(l_response, 'null')
               || '}';

    exception
        when others then
            return '{"status_code":0,"error":"'
                   || replace(sqlerrm, '"', '''')
                   || '"}';
    end send_whatsapp_request;

  /* =========================================================
     Send Signup OTP (TEMPLATE)
     ========================================================= */
    function send_signup_otp (
        p_to  in varchar2,
        p_otp in varchar2
    ) return clob is
        l_body clob;
    begin
        l_body := '{
    "messaging_product": "whatsapp",
    "to": "'
                  || p_to
                  || '",
    "type": "template",
    "template": {
      "name": "otp",
      "language": { "code": "en_US" },
      "components": [
        {
          "type": "body",
          "parameters": [
            { "type": "text", "text": "'
                  || p_otp
                  || '" }
          ]
        },
        {
          "type": "button",
          "sub_type": "url",
          "index": "0",
          "parameters": [
            { "type": "text", "text": "'
                  || p_otp
                  || '" }
          ]
        }
      ]
    }
  }';

        return send_whatsapp_request(l_body);
    end send_signup_otp;

  /* =========================================================
     Send Reset Password OTP (TEMPLATE)
     ========================================================= */
    function send_resetpass_otp (
        p_to  in varchar2,
        p_otp in varchar2
    ) return clob is
        l_body clob;
    begin
        l_body := '{
    "messaging_product": "whatsapp",
    "to": "'
                  || p_to
                  || '",
    "type": "template",
    "template": {
      "name": "otp",
      "language": { "code": "en_US" },
      "components": [
        {
          "type": "body",
          "parameters": [
            { "type": "text", "text": "'
                  || p_otp
                  || '" }
          ]
        },
        {
          "type": "button",
          "sub_type": "url",
          "index": "0",
          "parameters": [
            { "type": "text", "text": "'
                  || p_otp
                  || '" }
          ]
        }
      ]
    }
  }';

        return send_whatsapp_request(l_body);
    end send_resetpass_otp;

  /* =========================================================
     Generate OTP (USER BASED – FINAL)
     ========================================================= */
    procedure generate_otp (
        p_user_id  in varchar2,
        p_purpose  in varchar2,
        p_otp_id   out varchar2,
        p_otp_code out varchar2
    ) is
    begin
    -- Expire old OTPs for this user & purpose
        update otp_logs
        set
            is_used = 'Y'
        where
                user_id = p_user_id
            and purpose = p_purpose
            and nvl(is_used, 'N') = 'N';

    -- Generate 4-digit OTP
        p_otp_code := lpad(
            trunc(dbms_random.value(0, 9999)),
            4,
            '0'
        );

        insert into otp_logs (
            otp_id,
            user_id,
            otp_code,
            purpose,
            is_used,
            created_at,
            expires_at
        ) values ( substr(
            rawtohex(sys_guid()),
            1,
            30
        ),
                   p_user_id,
                   p_otp_code,
                   p_purpose,
                   'N',
                   systimestamp,
                   systimestamp + interval '5' minute ) returning otp_id into p_otp_id;

    end generate_otp;

end whatsapp_pkg;
/


-- sqlcl_snapshot {"hash":"6bd01cf3d95a01a4d94a1d0c4bd7c4cfda987588","type":"PACKAGE_BODY","name":"WHATSAPP_PKG","schemaName":"WKSP_ELWAGHA50","sxml":""}