-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464121543 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\unified_drivers_list.sql
-- sqlcl_snapshot src/database/dev_schema/views/unified_drivers_list.sql:null:a83dc5761d31316248e61529bb51c99ddbbf1ab1:create

create or replace force editionable view unified_drivers_list (
    driver_id,
    driver_name,
    assignment_type,
    profile_photo,
    contact_phone,
    contact_email,
    contact_address,
    driver_supplier_type,
    status,
    join_date,
    notes
) as
    select
        cd.driver_id,
        cd.driver_name,
        'INSOURCE' as assignment_type,
        case
            when cd.photo_url is not null then
                cd.photo_url
            else
                'https://g84c211b3b16868-apexadb1.adb.me-jeddah-1.oraclecloudapps.com/ords/r/blitzlayali333/135/files/static/v282/placeholders/unknown.png'
        end        as profile_photo,
        cd.phone   as contact_phone,
        cd.email   as contact_email,
        cd.address as contact_address,
        'INSOURCE' as driver_supplier_type,
        cd.status,
        cd.join_date,
        cd.notes
    from
        company_drivers cd
    union all

-- 🎯 All Suppliers with SUPPLIER_TYPE_ID = 30
    select
        s.supplier_id   as driver_id,
        s.supplier_name as driver_name,
        'OUTSOURCE'     as assignment_type,
        case
            when s.photo_url is not null then
                s.photo_url
            else
                'https://g84c211b3b16868-apexadb1.adb.me-jeddah-1.oraclecloudapps.com/ords/r/blitzlayali333/135/files/static/v282/placeholders/unknown.png'
        end             as profile_photo,
        s.phone         as contact_phone,
        s.email         as contact_email,
        s.address       as contact_address,
        'OUTSOURCE'     as driver_supplier_type,
        s.status,
        null            as join_date,
        s.notes
    from
        suppliers s
    where
        s.supplier_type_id = 30;

