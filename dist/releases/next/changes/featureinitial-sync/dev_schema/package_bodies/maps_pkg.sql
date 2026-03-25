-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463865164 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\maps_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/maps_pkg.sql:null:487cb26f4654683f3b54d499e0807a849499fb14:create

create or replace package body maps_pkg as

  -- خلي الـ key في Application Setting / Table / Vault (مش هاردهاردكود)
  -- هنا مثال: Application Setting اسمها GOOGLE_ROUTES_KEY
    function get_routes_key return varchar2 is
    begin
        return apex_app_setting.get_value('GOOGLE_ROUTES_KEY');
    exception
        when others then
            return null;
    end;

    procedure compute_route_by_place_id (
        p_from_place_id in varchar2,
        p_to_place_id   in varchar2,
        o_distance_km   out number,
        o_duration_min  out number,
        o_raw_json      out clob
    ) is

        l_url        varchar2(4000) := 'https://routes.googleapis.com/directions/v2:computeRoutes';
        l_key        varchar2(4000);
        l_body       clob;
        l_resp       clob;
        j            apex_json.t_values;
        l_distance_m number;
        l_duration_s number;
        l_dur_txt    varchar2(100); -- أحيانًا duration بتيجي "123s" (نص)
    begin
        o_distance_km := null;
        o_duration_min := null;
        o_raw_json := null;
        if p_from_place_id is null
           or p_to_place_id is null then
            raise_application_error(-20001, 'FROM/TO place_id is required');
        end if;

        l_key := get_routes_key;
        if l_key is null then
            raise_application_error(-20002, 'Google Routes API key not configured');
        end if;

    -- Build JSON body (Origin/Destination using placeId)
        apex_json.initialize_clob_output;
        apex_json.open_object;
        apex_json.open_object('origin');
        apex_json.open_object('placeId'); -- غلط: placeId مش object
        apex_json.close_object;
        apex_json.close_object;
        apex_json.free_output;

    -- نبنيها صح يدويًا كـ CLOB بسيط وواضح
        l_body := '{'
                  || ' "origin": { "placeId": "'
                  || apex_escape.json(p_from_place_id)
                  || '" },'
                  || ' "destination": { "placeId": "'
                  || apex_escape.json(p_to_place_id)
                  || '" },'
                  || ' "travelMode": "DRIVE",'
                  || ' "routingPreference": "TRAFFIC_AWARE",'
                  || ' "computeAlternativeRoutes": false,'
                  || ' "languageCode": "ar",'
                  || ' "units": "METRIC"'
                  || '}';

    -- Headers
        apex_web_service.g_request_headers.delete;
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';
        apex_web_service.g_request_headers(2).name := 'X-Goog-Api-Key';
        apex_web_service.g_request_headers(2).value := l_key;

    -- FieldMask مطلوب + خليكي محددة عشان performance
        apex_web_service.g_request_headers(3).name := 'X-Goog-FieldMask';
        apex_web_service.g_request_headers(3).value := 'routes.distanceMeters,routes.duration';
        l_resp := apex_web_service.make_rest_request(
            p_url         => l_url,
            p_http_method => 'POST',
            p_body        => l_body
        );

        o_raw_json := l_resp;

    -- Parse JSON
        apex_json.parse(
            p_values => j,
            p_source => l_resp
        );

    -- distanceMeters: رقم
        l_distance_m := apex_json.get_number(
            p_values => j,
            p_path   => 'routes[1].distanceMeters'
        );

    -- duration: غالبًا "123s" (string) في Routes API examples
        l_dur_txt := apex_json.get_varchar2(
            p_values => j,
            p_path   => 'routes[1].duration'
        );

    -- استخرج الرقم من "123s"
        l_duration_s := to_number ( regexp_replace(
            nvl(l_dur_txt, '0s'),
            '[^0-9]',
            ''
        ) );

        o_distance_km := round(l_distance_m / 1000, 2);
        o_duration_min := round(l_duration_s / 60, 0);
    exception
        when others then
      -- رجعي رسالة واضحة (ممكن كمان تخزني l_resp للديباج)
            raise_application_error(-20099, 'compute_route failed: ' || sqlerrm);
    end compute_route_by_place_id;

end maps_pkg;
/

