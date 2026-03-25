-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463844961 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\indexes\ux_fast_track_service_name.sql
-- sqlcl_snapshot src/database/dev_schema/indexes/ux_fast_track_service_name.sql:null:1bb87ae8300e15d3713a4d9384704c450f9025ce:create

create unique index ux_fast_track_service_name on
    fast_track_service_catalog (
        service_name
    );

