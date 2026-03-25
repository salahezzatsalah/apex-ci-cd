-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464138159 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_reservation_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_reservation_statuses.sql:null:8dd856082ddee914f431341714b34ff715e0bd18:create

create or replace force editionable view vw_reservation_statuses (
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
        reservation_statuses
    where
        is_active = 'Y';

