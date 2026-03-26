BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled             => TRUE,
        p_schema              => 'WKSP_ELWAGHA50',
        p_url_mapping_type    => 'BASE_PATH',
        p_url_mapping_pattern => 'wksp_elwagha50',
        p_auto_rest_auth      => FALSE
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20049 THEN
            NULL; -- Ignore "already enabled" error
        ELSE
            RAISE;
        END IF;
END;
/
