-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464133965 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_limo_res_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_limo_res_statuses.sql:null:9f49884770af3d10c09b7fa28b30607fe4f9cf45:create

create or replace force editionable view vw_limo_res_statuses (
    status_code,
    status_label_ar,
    status_label_en,
    status_badge_class,
    status_order
) as
    select
        status_code,
        status_label_ar,
        status_label_en,
        status_badge_class,
        status_order
    from
        limo_res_statuses
    where
        is_active = 'Y';

