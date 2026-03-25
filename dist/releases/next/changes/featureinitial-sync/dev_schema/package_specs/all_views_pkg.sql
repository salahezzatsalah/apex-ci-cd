-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463873188 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\all_views_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/all_views_pkg.sql:null:0723f8b74a6e7590c15d5acfec1712b766781e69:create

create or replace package all_views_pkg as
    procedure create_driver (
        p_driver_name         in company_drivers.driver_name%type,
        p_national_id         in company_drivers.national_id%type,
        p_license_number      in company_drivers.license_number%type,
        p_license_expiry_date in company_drivers.license_expiry_date%type,
        p_phone               in company_drivers.phone%type,
        p_email               in company_drivers.email%type,
        p_address             in company_drivers.address%type,
        p_city                in company_drivers.city%type,
        p_country_id          in company_drivers.country_id%type,
        p_status              in company_drivers.status%type,
        p_join_date           in company_drivers.join_date%type,
        p_is_active_employee  in company_drivers.is_active_employee%type,
        p_department_id       in company_drivers.department_id%type,
        p_notes               in company_drivers.notes%type,
        p_has_portal_access   in company_drivers.has_portal_access%type,
        p_username            in company_drivers.username%type,
        p_password_hash       in company_drivers.password_hash%type,
        p_profile_photo       in varchar2 default null
    );

    procedure update_driver (
        p_driver_id           in company_drivers.driver_id%type,
        p_driver_name         in company_drivers.driver_name%type,
        p_national_id         in company_drivers.national_id%type,
        p_license_number      in company_drivers.license_number%type,
        p_license_expiry_date in company_drivers.license_expiry_date%type,
        p_phone               in company_drivers.phone%type,
        p_email               in company_drivers.email%type,
        p_address             in company_drivers.address%type,
        p_city                in company_drivers.city%type,
        p_country_id          in company_drivers.country_id%type,
        p_status              in company_drivers.status%type,
        p_join_date           in company_drivers.join_date%type,
        p_is_active_employee  in company_drivers.is_active_employee%type,
        p_department_id       in company_drivers.department_id%type,
        p_notes               in company_drivers.notes%type,
        p_has_portal_access   in company_drivers.has_portal_access%type,
        p_username            in company_drivers.username%type,
        p_password_hash       in company_drivers.password_hash%type,
        p_profile_photo       in varchar2 default null
    );

    procedure delete_driver (
        p_driver_id in company_drivers.driver_id%type
    );

    procedure create_car (
        p_car_name           in company_registered_cars.car_name%type,
        p_car_type_id        in company_registered_cars.car_type_id%type,
        p_model_name         in company_registered_cars.model_name%type,
        p_year               in number,
        p_license_plate      in company_registered_cars.license_plate%type,
        p_color              in company_registered_cars.color%type,
        p_chassis_number     in company_registered_cars.chassis_number%type,
        p_status             in company_registered_cars.status%type,
        p_notes              in company_registered_cars.notes%type,
        p_profile_photo_blob in varchar2 default null,
        p_created_by         in varchar2 default user
    );

  -- Procedure to update an existing company car
    procedure update_car (
        p_car_id             in company_registered_cars.id%type,
        p_car_name           in company_registered_cars.car_name%type,
        p_car_type_id        in company_registered_cars.car_type_id%type,
        p_model_name         in company_registered_cars.model_name%type,
        p_year               in number,
        p_license_plate      in company_registered_cars.license_plate%type,
        p_color              in company_registered_cars.color%type,
        p_chassis_number     in company_registered_cars.chassis_number%type,
        p_status             in company_registered_cars.status%type,
        p_notes              in company_registered_cars.notes%type,
        p_profile_photo_blob in varchar2 default null,
        p_updated_by         in varchar2 default user
    );

  -- Procedure to delete a company car
    procedure delete_car (
        p_car_id in company_registered_cars.id%type
    );

    procedure insert_employee (
        p_email             in bs_employees.email%type,
        p_phone_number      in bs_employees.phone_number%type,
        p_first_name        in bs_employees.first_name%type,
        p_last_name         in bs_employees.last_name%type,
        p_national_id       in bs_employees.national_id%type,
        p_location          in bs_employees.location%type,
        p_password_hash     in bs_employees.password_hash%type,
        p_city              in bs_employees.city%type,
        p_country_id        in bs_employees.country_id%type,
        p_initials          in bs_employees.initials%type,
        p_tags              in bs_employees.tags%type,
        p_job_title         in bs_employees.job_title%type,
        p_username          in bs_employees.username%type,
        p_account_locked_yn in bs_employees.account_locked_yn%type,
        p_join_date         in bs_employees.join_date%type,
        p_full_time_yn      in bs_employees.full_time_yn%type,
        p_department_id     in bs_employees.department_id%type,
        p_dept_leader_yn    in bs_employees.dept_leader_yn%type,
        p_screen_name       in bs_employees.screen_name%type,
        p_status            in bs_employees.status%type,
        p_photo             in varchar2 := null
    );

    procedure update_employee (
        p_id                in bs_employees.id%type,
        p_email             in bs_employees.email%type,
        p_phone_number      in bs_employees.phone_number%type,
        p_first_name        in bs_employees.first_name%type,
        p_last_name         in bs_employees.last_name%type,
        p_national_id       in bs_employees.national_id%type,
        p_location          in bs_employees.location%type,
        p_city              in bs_employees.city%type,
        p_country_id        in bs_employees.country_id%type,
        p_initials          in bs_employees.initials%type,
        p_tags              in bs_employees.tags%type,
        p_job_title         in bs_employees.job_title%type,
        p_username          in bs_employees.username%type,
        p_account_locked_yn in bs_employees.account_locked_yn%type,
        p_join_date         in bs_employees.join_date%type,
        p_full_time_yn      in bs_employees.full_time_yn%type,
        p_department_id     in bs_employees.department_id%type,
        p_dept_leader_yn    in bs_employees.dept_leader_yn%type,
        p_screen_name       in bs_employees.screen_name%type,
        p_status            in bs_employees.status%type,
        p_photo             in varchar2 := null
    );

    procedure delete_employee (
        p_id in bs_employees.id%type
    );

    procedure add_car_type (
        p_car_type_name      in limo_car_types.car_type_name%type,
        p_category           in limo_car_types.category%type,
        p_seats              in limo_car_types.seats%type,
        p_status             in limo_car_types.status%type,
        p_created_by         in varchar2 default user,
        p_model_year         in limo_car_types.model_year%type default null,
        p_max_passengers     in limo_car_types.max_passengers%type default null,
        p_max_luggage        in limo_car_types.max_luggage%type default null,
        p_personal_driver_yn in limo_car_types.personal_driver_yn%type default 'Y',
        p_main_photo         in varchar2 default null,
        p_profile_picture    in varchar2 default null
    );

    procedure update_car_type (
        p_car_type_id        in limo_car_types.car_type_id%type,
        p_car_type_name      in limo_car_types.car_type_name%type,
        p_category           in limo_car_types.category%type,
        p_seats              in limo_car_types.seats%type,
        p_status             in limo_car_types.status%type,
        p_updated_by         in varchar2 default user,
        p_model_year         in limo_car_types.model_year%type default null,
        p_max_passengers     in limo_car_types.max_passengers%type default null,
        p_max_luggage        in limo_car_types.max_luggage%type default null,
        p_personal_driver_yn in limo_car_types.personal_driver_yn%type default 'Y',
        p_main_photo         in varchar2 default null,
        p_profile_picture    in varchar2 default null
    );

    procedure delete_car_type (
        p_car_type_id in limo_car_types.car_type_id%type
    );

    procedure add_fast_track_service (
        p_service_name     in fast_track_service_catalog.service_name%type,
        p_service_desc     in fast_track_service_catalog.service_desc%type default null,
        p_active           in fast_track_service_catalog.active%type default 'Y',
        p_default_price    in fast_track_service_catalog.default_price%type default null,
        p_default_currency in fast_track_service_catalog.default_currency%type default 'EGP',
        p_is_per_person    in fast_track_service_catalog.is_per_person%type default 'Y',
        p_is_vat_included  in fast_track_service_catalog.is_vat_included%type default 'N',
        p_created_by       in varchar2 default user,
        p_service_pic      in varchar2 default null,  -- APEX temp file NAME
        p_service_id_out   out fast_track_service_catalog.service_id%type
    );

    procedure update_fast_track_service (
        p_service_id       in fast_track_service_catalog.service_id%type,
        p_service_name     in fast_track_service_catalog.service_name%type,
        p_service_desc     in fast_track_service_catalog.service_desc%type default null,
        p_active           in fast_track_service_catalog.active%type default 'Y',
        p_default_price    in fast_track_service_catalog.default_price%type default null,
        p_default_currency in fast_track_service_catalog.default_currency%type default 'EGP',
        p_is_per_person    in fast_track_service_catalog.is_per_person%type default 'Y',
        p_is_vat_included  in fast_track_service_catalog.is_vat_included%type default 'N',
        p_updated_by       in varchar2 default user,
        p_service_pic      in varchar2 default null -- APEX temp file name
    );

    procedure insert_supplier (
        p_supplier_name     in suppliers.supplier_name%type,
        p_is_company        in suppliers.is_company%type,
        p_supplier_type_id  in suppliers.supplier_type_id%type,
        p_national_id       in suppliers.national_id%type,
        p_tax_id            in suppliers.tax_id%type,
        p_phone             in suppliers.phone%type,
        p_email             in suppliers.email%type,
        p_address           in suppliers.address%type,
        p_city              in suppliers.city%type,
        p_country_id        in suppliers.country_id%type,
        p_notes             in suppliers.notes%type,
        p_company_reg_no    in suppliers.company_reg_no%type,
        p_contact_person    in suppliers.contact_person%type,
        p_has_portal_access in suppliers.has_portal_access%type,
        p_username          in suppliers.username%type,
        p_password_hash     in suppliers.password_hash%type,
        p_status            in suppliers.status%type,
        p_profile_photo     in varchar2 default null
    );

    procedure update_supplier (
        p_supplier_id       in suppliers.supplier_id%type,
        p_supplier_name     in suppliers.supplier_name%type,
        p_is_company        in suppliers.is_company%type,
        p_supplier_type_id  in suppliers.supplier_type_id%type,
        p_national_id       in suppliers.national_id%type,
        p_tax_id            in suppliers.tax_id%type,
        p_phone             in suppliers.phone%type,
        p_email             in suppliers.email%type,
        p_address           in suppliers.address%type,
        p_city              in suppliers.city%type,
        p_country_id        in suppliers.country_id%type,
        p_notes             in suppliers.notes%type,
        p_company_reg_no    in suppliers.company_reg_no%type,
        p_contact_person    in suppliers.contact_person%type,
        p_has_portal_access in suppliers.has_portal_access%type,
        p_username          in suppliers.username%type,
        p_password_hash     in suppliers.password_hash%type,
        p_status            in suppliers.status%type,
        p_profile_photo     in varchar2 default null
    );

    procedure delete_supplier (
        p_supplier_id in suppliers.supplier_id%type
    );

end all_views_pkg;
/

