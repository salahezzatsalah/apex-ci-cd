create or replace package body car_api as

    procedure create_car_zip (
        p_car_id in varchar2
    ) is

        l_source_bucket  varchar2(200) := app_config.g_default_bucket;
        l_target_bucket  varchar2(200) := app_config.g_default_bucket || '/my_zips/';
        l_zip_name       varchar2(200) := 'CAR_'
                                    || p_car_id
                                    || '.zip';
        l_response       dbms_cloud_types.resp;
        l_response_text  clob;
        l_json_resp      json_object_t;
        l_check_response clob;
        l_attempts       pls_integer := 0;
        l_max_attempts   pls_integer := 10;
        l_zip_exists     boolean := false;
    begin
        l_response := dbms_cloud.send_request(
            credential_name => 'o_storagekey',
            uri             => 'https://functions.us-ashburn-1.oci.oraclecloud.com/20181201/functions/<function_ocid>/actions/invoke'
            ,
            method          => dbms_cloud.method_post,
            body            => utl_raw.cast_to_raw('{
                    "COMPARTMENT_ID": "ocid1.bucket.oc1.me-jeddah-1.aaaaaaaal4ptx4vhxoibdg4njm7e54j2gkeo4gwprgveg33ac7nxbvpowp7a",
                    "REGION": "me-jeddah-1",
                    "SOURCE_BUCKET": "'
                                        || l_source_bucket
                                        || '",
                    "SOURCE_FILES": "COMPANY_REGISTERED_CARS_AVATAR/'
                                        || p_car_id
                                        || '/",
                    "TARGET_BUCKET": "'
                                        || l_target_bucket
                                        || l_zip_name || '",
                    "ALLOW_OVERWRITE": "true"
                }')
        );

        l_response_text := dbms_cloud.get_response_text(l_response);
        begin
            l_json_resp := json_object_t.parse(l_response_text);
        exception
            when others then
                null;
        end;

        while l_attempts < l_max_attempts loop
            begin
                l_check_response := apex_web_service.make_rest_request(
                    p_url                  => 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                             || l_target_bucket
                             || l_zip_name,
                    p_http_method          => 'HEAD',
                    p_credential_static_id => 'o_storagekey'
                );

                l_zip_exists := true;
                exit;
            exception
                when others then
                    l_zip_exists := false;
                    l_attempts := l_attempts + 1;
            end;
        end loop;

        apex_json.open_object;
        apex_json.write('zip_url', 'https://objectstorage.me-jeddah-1.oraclecloud.com/n/axiuwmrz0vs3/b/'
                                   || l_target_bucket
                                   || l_zip_name);
        apex_json.write('status',
                        case
                            when l_zip_exists then
                                'Success'
                            else
                                'Pending/Error'
                        end
        );
        apex_json.close_object;
    exception
        when others then
            apex_json.open_object;
            apex_json.write('error', sqlerrm);
            apex_json.close_object;
    end create_car_zip;

end car_api;
/


-- sqlcl_snapshot {"hash":"890dad05e4a3f9e6d22fd5892599f2fce7f0cfe4","type":"PACKAGE_BODY","name":"CAR_API","schemaName":"DEV_SCHEMA","sxml":""}