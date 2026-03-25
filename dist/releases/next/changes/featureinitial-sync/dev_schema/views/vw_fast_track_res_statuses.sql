-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464131010 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_fast_track_res_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_fast_track_res_statuses.sql:null:66ae2bd91087b41fb31777bdc0db196e516d1337:create

create or replace force editionable view vw_fast_track_res_statuses (
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
        fast_track_res_statuses
    where
        is_active = 'Y';

