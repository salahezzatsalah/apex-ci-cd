-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463850888 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\all_views_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/all_views_pkg.sql:null:e101a39359ad3222c99d14acba479c35e53542f4:create

create or replace package body all_views_pkg as

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
    ) is

        l_driver_id   varchar2(300);
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
    begin
        insert into company_drivers (
            driver_name,
            national_id,
            license_number,
            license_expiry_date,
            phone,
            email,
            address,
            city,
            country_id,
            status,
            join_date,
            is_active_employee,
            department_id,
            notes,
            has_portal_access,
            username,
            password_hash
        ) values ( p_driver_name,
                   p_national_id,
                   p_license_number,
                   p_license_expiry_date,
                   p_phone,
                   p_email,
                   p_address,
                   p_city,
                   p_country_id,
                   p_status,
                   p_join_date,
                   p_is_active_employee,
                   p_department_id,
                   p_notes,
                   p_has_portal_access,
                   p_username,
                   p_password_hash ) returning driver_id into l_driver_id;

        if p_profile_photo is not null then
            select
                blob_content,
                filename
            into
                l_blob,
                l_filename
            from
                apex_application_temp_files
            where
                name = p_profile_photo;

            l_extension := lower(nvl(
                regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                '.jpg'
            ));
            l_object_name := 'DRIVER_AVATAR/'
                             || l_driver_id
                             || l_extension;
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.upload_file(
                p_parent_name => 'DRIVER_AVATAR',
                p_filename    => l_driver_id || l_extension,
                p_blob        => l_blob
            );

            l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                            || drive_crud_api.create_par(
                p_object_name  => l_object_name,
                p_par_name     => 'driver-'
                              || l_driver_id
                              || '-par',
                p_time_expires => add_months(systimestamp, 12)
            );

            update company_drivers
            set
                photo_url = l_public_url
            where
                driver_id = l_driver_id;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20002, 'Driver insert/upload failed: ' || sqlerrm);
    end create_driver;

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
    ) is

        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
        l_old_url     varchar2(2000);
    begin
        update company_drivers
        set
            driver_name = p_driver_name,
            national_id = p_national_id,
            license_number = p_license_number,
            license_expiry_date = p_license_expiry_date,
            phone = p_phone,
            email = p_email,
            address = p_address,
            city = p_city,
            country_id = p_country_id,
            status = p_status,
            join_date = p_join_date,
            is_active_employee = p_is_active_employee,
            department_id = p_department_id,
            notes = p_notes,
            has_portal_access = p_has_portal_access,
            username = p_username,
            password_hash = p_password_hash
        where
            driver_id = p_driver_id;

        if p_profile_photo is not null then
            select
                blob_content,
                filename
            into
                l_blob,
                l_filename
            from
                apex_application_temp_files
            where
                name = p_profile_photo;

            l_extension := lower(nvl(
                regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                '.jpg'
            ));
            l_object_name := 'DRIVER_AVATAR/'
                             || p_driver_id
                             || l_extension;
            drive_crud_api.set_bucket(app_config.g_default_bucket);

      -- Delete old photo if exists
            begin
                select
                    photo_url
                into l_old_url
                from
                    company_drivers
                where
                        driver_id = p_driver_id
                    and photo_url is not null;

                drive_crud_api.delete_file(substr(l_old_url,
                                                  instr(l_old_url, 'DRIVER_AVATAR')));
            exception
                when no_data_found then
                    null;
            end;

      -- Upload new photo
            drive_crud_api.upload_file(
                p_parent_name => 'DRIVER_AVATAR',
                p_filename    => p_driver_id || l_extension,
                p_blob        => l_blob
            );

            l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                            || drive_crud_api.create_par(
                p_object_name  => l_object_name,
                p_par_name     => 'driver-'
                              || p_driver_id
                              || '-par',
                p_time_expires => add_months(systimestamp, 12)
            );

            update company_drivers
            set
                photo_url = l_public_url,
                photo_last_updated = systimestamp
            where
                driver_id = p_driver_id;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20003, 'Driver update failed: ' || sqlerrm);
    end update_driver;

    procedure delete_driver (
        p_driver_id in company_drivers.driver_id%type
    ) is
        l_old_url     varchar2(2000);
        l_object_name varchar2(400);
    begin
    -- Attempt to delete photo first
        begin
            select
                photo_url
            into l_old_url
            from
                company_drivers
            where
                    driver_id = p_driver_id
                and photo_url is not null;

            l_object_name := substr(l_old_url,
                                    instr(l_old_url, 'DRIVER_AVATAR'));
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.delete_file(l_object_name);
        exception
            when no_data_found then
                null;
            when others then
                dbms_output.put_line('Photo delete failed: ' || sqlerrm);
        end;

    -- Delete driver record
        delete from company_drivers
        where
            driver_id = p_driver_id;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20002, 'Driver delete failed: ' || sqlerrm);
    end delete_driver;

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
    ) is

        l_car_id      company_registered_cars.id%type;
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
    begin
        insert into company_registered_cars (
            car_name,
            car_type_id,
            model_name,
            year,
            license_plate,
            color,
            chassis_number,
            status,
            notes,
            created_by
        ) values ( p_car_name,
                   p_car_type_id,
                   p_model_name,
                   p_year,
                   p_license_plate,
                   p_color,
                   p_chassis_number,
                   p_status,
                   p_notes,
                   p_created_by ) returning id into l_car_id;

        if p_profile_photo_blob is not null then
            select
                blob_content,
                filename
            into
                l_blob,
                l_filename
            from
                apex_application_temp_files
            where
                name = p_profile_photo_blob;

            l_extension := lower(nvl(
                regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                '.jpg'
            ));
            l_object_name := 'COMPANY_REGISTERED_CARS_AVATAR/'
                             || l_car_id
                             || '/'
                             || l_car_id
                             || l_extension;
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.upload_file(
                p_parent_name => 'COMPANY_REGISTERED_CARS_AVATAR/' || l_car_id,
                p_filename    => l_car_id || l_extension,
                p_blob        => l_blob
            );

            l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                            || drive_crud_api.create_par(
                p_object_name  => l_object_name,
                p_par_name     => 'car-'
                              || l_car_id
                              || '-par',
                p_time_expires => add_months(systimestamp, 12)
            );

            update company_registered_cars
            set
                photo_url = l_public_url,
                updated = systimestamp
            where
                id = l_car_id;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20001, 'Company car creation failed: ' || sqlerrm);
    end create_car;

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
    ) is

        l_old_url     varchar2(4000);
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
    begin
        update company_registered_cars
        set
            car_name = p_car_name,
            car_type_id = p_car_type_id,
            model_name = p_model_name,
            year = p_year,
            license_plate = p_license_plate,
            color = p_color,
            chassis_number = p_chassis_number,
            status = p_status,
            notes = p_notes,
            updated_by = p_updated_by,
            updated = systimestamp
        where
            id = p_car_id;

        if p_profile_photo_blob is not null then
      -- Delete old photo if exists
            begin
                select
                    photo_url
                into l_old_url
                from
                    company_registered_cars
                where
                        id = p_car_id
                    and photo_url is not null;

                l_object_name := regexp_substr(l_old_url, 'COMPANY_REGISTERED_CARS_AVATAR/[^?]+');
                if l_object_name is not null then
                    drive_crud_api.set_bucket(app_config.g_default_bucket);
                    begin
                        drive_crud_api.delete_file(l_object_name);
                    exception
                        when others then
                            dbms_output.put_line('Warning: old file not deleted - ' || sqlerrm);
                    end;

                end if;

            exception
                when no_data_found then
                    null;
            end;

      -- Upload new photo
            select
                blob_content,
                filename
            into
                l_blob,
                l_filename
            from
                apex_application_temp_files
            where
                name = p_profile_photo_blob;

            l_extension := lower(nvl(
                regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                '.jpg'
            ));
            l_object_name := 'COMPANY_REGISTERED_CARS_AVATAR/'
                             || p_car_id
                             || '/'
                             || p_car_id
                             || l_extension;
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.upload_file(
                p_parent_name => 'COMPANY_REGISTERED_CARS_AVATAR/' || p_car_id,
                p_filename    => p_car_id || l_extension,
                p_blob        => l_blob
            );

      -- Create PAR URL
            update company_registered_cars
            set
                photo_url = 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                            || drive_crud_api.create_par(
                    p_object_name  => l_object_name,
                    p_par_name     => 'car-'
                                  || p_car_id
                                  || '-par',
                    p_time_expires => add_months(systimestamp, 12)
                ),
                updated = systimestamp,
                updated_by = p_updated_by
            where
                id = p_car_id;

        end if;

        commit;
    exception
        when no_data_found then
            raise_application_error(-20002, 'Car not found.');
        when others then
            rollback;
            raise_application_error(-20003, 'Company car update failed: ' || sqlerrm);
    end update_car;

    procedure delete_car (
        p_car_id in company_registered_cars.id%type
    ) is
    begin
        begin
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.delete_folder('COMPANY_REGISTERED_CARS_AVATAR/' || p_car_id);
        exception
            when others then
                dbms_output.put_line('Warning: folder not deleted - ' || sqlerrm);
        end;

        delete from company_registered_cars
        where
            id = p_car_id;

        commit;
    exception
        when no_data_found then
            raise_application_error(-20002, 'Car not found.');
        when others then
            rollback;
            raise_application_error(-20003, 'Car delete failed: ' || sqlerrm);
    end delete_car;

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
    ) is

        l_id          varchar2(300);
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
    begin
        insert into bs_employees (
            email,
            phone_number,
            first_name,
            last_name,
            national_id,
            location,
            password_hash,
            city,
            country_id,
            initials,
            tags,
            job_title,
            username,
            account_locked_yn,
            join_date,
            full_time_yn,
            department_id,
            dept_leader_yn,
            screen_name,
            status
        ) values ( p_email,
                   p_phone_number,
                   p_first_name,
                   p_last_name,
                   p_national_id,
                   p_location,
                   p_password_hash,
                   p_city,
                   p_country_id,
                   p_initials,
                   p_tags,
                   p_job_title,
                   p_username,
                   p_account_locked_yn,
                   p_join_date,
                   p_full_time_yn,
                   p_department_id,
                   p_dept_leader_yn,
                   p_screen_name,
                   p_status ) returning id into l_id;

        if p_photo is not null then
            select
                blob_content,
                filename
            into
                l_blob,
                l_filename
            from
                apex_application_temp_files
            where
                name = p_photo;

            l_extension := lower(nvl(
                regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                '.jpg'
            ));
            l_object_name := 'EMPLOYEE_AVATAR/'
                             || l_id
                             || l_extension;
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.upload_file(
                p_parent_name => 'EMPLOYEE_AVATAR',
                p_filename    => l_id || l_extension,
                p_blob        => l_blob
            );

            l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                            || drive_crud_api.create_par(
                p_object_name  => l_object_name,
                p_par_name     => 'employee-'
                              || l_id
                              || '-par',
                p_time_expires => add_months(systimestamp, 12)
            );

            update bs_employees
            set
                photo_url = l_public_url
            where
                id = l_id;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20001, 'Employee insert/upload failed: ' || sqlerrm);
    end insert_employee;

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
    ) is

        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
        l_old_url     varchar2(4000);
        l_old_object  varchar2(400);
    begin
        update bs_employees
        set
            email = p_email,
            phone_number = p_phone_number,
            first_name = p_first_name,
            last_name = p_last_name,
            national_id = p_national_id,
            location = p_location,
            city = p_city,
            country_id = p_country_id,
            initials = p_initials,
            tags = p_tags,
            job_title = p_job_title,
            username = p_username,
            account_locked_yn = p_account_locked_yn,
            join_date = p_join_date,
            full_time_yn = p_full_time_yn,
            department_id = p_department_id,
            dept_leader_yn = p_dept_leader_yn,
            screen_name = p_screen_name,
            status = p_status
        where
            id = p_id;

        if p_photo is not null then
            select
                photo_url
            into l_old_url
            from
                bs_employees
            where
                id = p_id;

            if l_old_url is not null then
                l_old_object := regexp_substr(l_old_url, 'EMPLOYEE_AVATAR/.*$');
                if l_old_object is not null then
                    drive_crud_api.set_bucket(app_config.g_default_bucket);
                    drive_crud_api.delete_file(l_old_object);
                end if;

            end if;

            select
                blob_content,
                filename
            into
                l_blob,
                l_filename
            from
                apex_application_temp_files
            where
                name = p_photo;

            l_extension := lower(nvl(
                regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                '.jpg'
            ));
            l_object_name := 'EMPLOYEE_AVATAR/'
                             || p_id
                             || l_extension;
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.upload_file(
                p_parent_name => 'EMPLOYEE_AVATAR',
                p_filename    => p_id || l_extension,
                p_blob        => l_blob
            );

            l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                            || drive_crud_api.create_par(
                p_object_name  => l_object_name,
                p_par_name     => 'employee-'
                              || p_id
                              || '-par',
                p_time_expires => add_months(systimestamp, 12)
            );

            update bs_employees
            set
                photo_url = l_public_url
            where
                id = p_id;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20001, 'Employee update/upload failed: ' || sqlerrm);
    end update_employee;

    procedure delete_employee (
        p_id in bs_employees.id%type
    ) is
        l_old_url     varchar2(4000);
        l_object_name varchar2(400);
    begin
        select
            photo_url
        into l_old_url
        from
            bs_employees
        where
            id = p_id;

        if l_old_url is not null then
            begin
                l_object_name := regexp_substr(l_old_url, 'EMPLOYEE_AVATAR/.*$');
                drive_crud_api.set_bucket(app_config.g_default_bucket);
                drive_crud_api.delete_file(l_object_name);
            exception
                when others then
                    null;
            end;

        end if;

        delete from bs_employees
        where
            id = p_id;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20001, 'Employee delete failed: ' || sqlerrm);
    end delete_employee;

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
    ) is

        l_car_type_id varchar2(255);
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
    begin

      -- 1️⃣ Insert new car type
        insert into limo_car_types (
            car_type_name,
            category,
            seats,
            status,
            created_by,
            model_year,
            max_passengers,
            max_luggage,
            personal_driver_yn
        ) values ( p_car_type_name,
                   p_category,
                   p_seats,
                   p_status,
                   p_created_by,
                   p_model_year,
                   p_max_passengers,
                   p_max_luggage,
                   p_personal_driver_yn ) returning car_type_id into l_car_type_id;

        if trim(p_main_photo) is not null then
            begin
                select
                    blob_content,
                    filename
                into
                    l_blob,
                    l_filename
                from
                    apex_application_temp_files
                where
                    name = trim(p_main_photo);

                l_extension := lower(nvl(
                    regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                    '.jpg'
                ));
                l_object_name := 'CAR_TYPES_MAIN/'
                                 || l_car_type_id
                                 || l_extension;
                drive_crud_api.set_bucket(app_config.g_default_bucket);
                drive_crud_api.upload_file(
                    p_parent_name => 'CAR_TYPES_MAIN',
                    p_filename    => l_car_type_id || l_extension,
                    p_blob        => l_blob
                );

                l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                || drive_crud_api.create_par(
                    p_object_name  => l_object_name,
                    p_par_name     => 'car-main-'
                                  || l_car_type_id
                                  || '-par',
                    p_time_expires => add_months(systimestamp, 12)
                );

                update limo_car_types
                set
                    main_photo_url = l_public_url,
                    updated = systimestamp
                where
                    car_type_id = l_car_type_id;

            exception
                when no_data_found then
                    null;  -- الصورة مش موجودة في temp
            end;

        end if;

      -- 2️⃣ Upload profile picture if exists
        if trim(p_profile_picture) is not null then
            declare
                l_file_names apex_t_varchar2;
                l_temp_name  varchar2(4000);
                l_urls       apex_t_varchar2 := apex_t_varchar2();
                l_json       clob;
            begin
                l_file_names := apex_string.split(p_profile_picture, ':');
                for i in 1..l_file_names.count loop
                    l_temp_name := trim(l_file_names(i));
                    if l_temp_name is null then
                        continue;
                    end if;
                    begin
                        select
                            blob_content,
                            filename
                        into
                            l_blob,
                            l_filename
                        from
                            apex_application_temp_files
                        where
                            name = l_temp_name;

                    exception
                        when no_data_found then
                            continue; -- الملف مش موجود في temp
                    end;

                    l_extension := lower(nvl(
                        regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                        '.jpg'
                    ));
                    l_object_name := 'CAR_TYPES_AVATAR/'
                                     || l_car_type_id
                                     || '_'
                                     || i
                                     || l_extension;
                    drive_crud_api.set_bucket(app_config.g_default_bucket);
                    drive_crud_api.upload_file(
                        p_parent_name => 'CAR_TYPES_AVATAR',
                        p_filename    => l_car_type_id
                                      || '_'
                                      || i
                                      || l_extension,
                        p_blob        => l_blob
                    );

                    l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                    || drive_crud_api.create_par(
                        p_object_name  => l_object_name,
                        p_par_name     => 'car-'
                                      || l_car_type_id
                                      || '-'
                                      || i
                                      || '-par',
                        p_time_expires => add_months(systimestamp, 12)
                    );

                    l_urls.extend;
                    l_urls(l_urls.count) := l_public_url;
                end loop;

        -- build JSON array
                l_json := '[';
                for j in 1..l_urls.count loop
                    if j > 1 then
                        l_json := l_json || ',';
                    end if;
                    l_json := l_json
                              || '"'
                              || replace(
                        l_urls(j),
                        '"',
                        '\"'
                    )
                              || '"';

                end loop;

                l_json := l_json || ']';
                update limo_car_types
                set
                    photo_url = l_json,
                    updated = systimestamp
                where
                    car_type_id = l_car_type_id;

            end;
        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20001, 'Car type creation failed: ' || sqlerrm);
    end add_car_type;

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
    ) is

        l_blob          blob;
        l_filename      varchar2(255);
        l_extension     varchar2(20);
        l_object_name   varchar2(400);
        l_public_url    varchar2(4000);
        l_old_main_url  varchar2(4000);
        l_old_photo_url varchar2(4000);
    begin
  -- 1) Update basic info (بدون لمس الصور هنا)
        update limo_car_types
        set
            car_type_name = p_car_type_name,
            category = p_category,
            seats = p_seats,
            status = p_status,
            model_year = p_model_year,
            max_passengers = p_max_passengers,
            max_luggage = p_max_luggage,
            personal_driver_yn = p_personal_driver_yn,
            updated = systimestamp,
            updated_by = p_updated_by
        where
            car_type_id = p_car_type_id;

        if sql%rowcount = 0 then
            raise_application_error(-20002, 'Car type not found.');
        end if;

  -- 2) MAIN PHOTO (صورة واحدة)
        if trim(p_main_photo) is not null then
    -- (اختياري) احضار وحذف القديم لو موجود
            begin
                select
                    main_photo_url
                into l_old_main_url
                from
                    limo_car_types
                where
                    car_type_id = p_car_type_id;

                if l_old_main_url is not null then
                    l_object_name := regexp_substr(l_old_main_url, 'CAR_TYPES_MAIN/[^?]+');
                    if l_object_name is not null then
                        drive_crud_api.set_bucket(app_config.g_default_bucket);
                        begin
                            drive_crud_api.delete_file(l_object_name);
                        exception
                            when others then
                                null; -- تجاهل
                        end;
                    end if;

                end if;

            exception
                when no_data_found then
                    null;
            end;

    -- رفع الجديد
            begin
                select
                    blob_content,
                    filename
                into
                    l_blob,
                    l_filename
                from
                    apex_application_temp_files
                where
                    name = trim(p_main_photo);

                l_extension := lower(nvl(
                    regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                    '.jpg'
                ));
                l_object_name := 'CAR_TYPES_MAIN/'
                                 || p_car_type_id
                                 || l_extension;
                drive_crud_api.set_bucket(app_config.g_default_bucket);
                drive_crud_api.upload_file(
                    p_parent_name => 'CAR_TYPES_MAIN',
                    p_filename    => p_car_type_id || l_extension,
                    p_blob        => l_blob
                );

                l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                || drive_crud_api.create_par(
                    p_object_name  => l_object_name,
                    p_par_name     => 'car-main-'
                                  || p_car_type_id
                                  || '-par',
                    p_time_expires => add_months(systimestamp, 12)
                );

                update limo_car_types
                set
                    main_photo_url = l_public_url,
                    updated = systimestamp,
                    updated_by = p_updated_by
                where
                    car_type_id = p_car_type_id;

            exception
                when no_data_found then
                    null; -- temp file مش موجود
            end;

        end if;

  -- 3) GALLERY (عدة صور) -> PHOTO_URL JSON
        if trim(p_profile_picture) is not null then
            declare
                l_file_names apex_t_varchar2;
                l_temp_name  varchar2(4000);
                l_urls       apex_t_varchar2 := apex_t_varchar2();
                l_json       clob;
            begin
      -- (اختياري) حذف القديم لو مخزن كـ objects
                begin
                    select
                        photo_url
                    into l_old_photo_url
                    from
                        limo_car_types
                    where
                        car_type_id = p_car_type_id;

        -- لو حابة تحذفي القديم فعلاً لازم parsing للـ JSON وتdelete لكل object
        -- هنسيبه كده عشان ما نخاطرش بحذف غلط
                exception
                    when no_data_found then
                        null;
                end;

                l_file_names := apex_string.split(p_profile_picture, ':');
                for i in 1..l_file_names.count loop
                    l_temp_name := trim(l_file_names(i));
                    if l_temp_name is null then
                        continue;
                    end if;
                    begin
                        select
                            blob_content,
                            filename
                        into
                            l_blob,
                            l_filename
                        from
                            apex_application_temp_files
                        where
                            name = l_temp_name;

                    exception
                        when no_data_found then
                            continue;
                    end;

                    l_extension := lower(nvl(
                        regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                        '.jpg'
                    ));
                    l_object_name := 'CAR_TYPES_AVATAR/'
                                     || p_car_type_id
                                     || '_'
                                     || i
                                     || l_extension;
                    drive_crud_api.set_bucket(app_config.g_default_bucket);
                    drive_crud_api.upload_file(
                        p_parent_name => 'CAR_TYPES_AVATAR',
                        p_filename    => p_car_type_id
                                      || '_'
                                      || i
                                      || l_extension,
                        p_blob        => l_blob
                    );

                    l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                    || drive_crud_api.create_par(
                        p_object_name  => l_object_name,
                        p_par_name     => 'car-'
                                      || p_car_type_id
                                      || '-'
                                      || i
                                      || '-par',
                        p_time_expires => add_months(systimestamp, 12)
                    );

                    l_urls.extend;
                    l_urls(l_urls.count) := l_public_url;
                end loop;

      -- build JSON
                l_json := '[';
                for j in 1..l_urls.count loop
                    if j > 1 then
                        l_json := l_json || ',';
                    end if;
                    l_json := l_json
                              || '"'
                              || replace(
                        l_urls(j),
                        '"',
                        '\"'
                    )
                              || '"';

                end loop;

                l_json := l_json || ']';
                update limo_car_types
                set
                    photo_url = l_json,
                    updated = systimestamp,
                    updated_by = p_updated_by
                where
                    car_type_id = p_car_type_id;

            end;
        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20003, 'Car type update failed: ' || sqlerrm);
    end update_car_type;

    procedure delete_car_type (
        p_car_type_id in limo_car_types.car_type_id%type
    ) is
        l_object_name varchar2(400);
        l_photo_url   varchar2(4000);
    begin
    -- 1️⃣ جلب رابط الصورة من الجدول
        select
            photo_url
        into l_photo_url
        from
            limo_car_types
        where
            car_type_id = p_car_type_id;

    -- 2️⃣ حذف الصورة من Object Storage إذا كانت موجودة
        if l_photo_url is not null then
            l_object_name := regexp_substr(l_photo_url, 'CAR_TYPES_AVATAR/[^?]+');
            if l_object_name is not null then
                drive_crud_api.set_bucket(app_config.g_default_bucket);
                begin
                    drive_crud_api.delete_file(l_object_name);
                exception
                    when others then
                        dbms_output.put_line('Warning: could not delete file '
                                             || l_object_name
                                             || ' - ' || sqlerrm);
                end;

            end if;

        end if;

    -- 3️⃣ حذف السجل من الجدول
        delete from limo_car_types
        where
            car_type_id = p_car_type_id;

        commit;
    exception
        when no_data_found then
            raise_application_error(-20010, 'Car type not found.');
        when others then
            rollback;
            raise_application_error(-20011, 'Car type delete failed: ' || sqlerrm);
    end delete_car_type;

    procedure add_fast_track_service (
        p_service_name     in fast_track_service_catalog.service_name%type,
        p_service_desc     in fast_track_service_catalog.service_desc%type default null,
        p_active           in fast_track_service_catalog.active%type default 'Y',
        p_default_price    in fast_track_service_catalog.default_price%type default null,
        p_default_currency in fast_track_service_catalog.default_currency%type default 'EGP',
        p_is_per_person    in fast_track_service_catalog.is_per_person%type default 'Y',
        p_is_vat_included  in fast_track_service_catalog.is_vat_included%type default 'N',
        p_created_by       in varchar2 default user,
        p_service_pic      in varchar2 default null,  -- APEX temp file NAME (Fxxxx)
        p_service_id_out   out fast_track_service_catalog.service_id%type
    ) is

        l_service_id  fast_track_service_catalog.service_id%type;
        l_blob        blob;
        l_filename    varchar2(512);
        l_extension   varchar2(50);
        l_object_name varchar2(1000);
        l_public_url  varchar2(4000);
    begin
      -- Insert
        insert into fast_track_service_catalog (
            service_name,
            service_desc,
            active,
            default_price,
            default_currency,
            is_per_person,
            is_vat_included,
            created_by
        ) values ( p_service_name,
                   p_service_desc,
                   nvl(p_active, 'Y'),
                   p_default_price,
                   nvl(p_default_currency, 'EGP'),
                   nvl(p_is_per_person, 'Y'),
                   nvl(p_is_vat_included, 'N'),
                   p_created_by ) returning service_id into l_service_id;

        p_service_id_out := l_service_id;

      -- Upload picture (زي add_car_type)
        if trim(p_service_pic) is not null then
            begin
                select
                    blob_content,
                    filename
                into
                    l_blob,
                    l_filename
                from
                    apex_application_temp_files
                where
                    name = trim(p_service_pic);

                l_extension := lower(nvl(
                    regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                    '.jpg'
                ));
                l_object_name := 'FAST_TRACK_SERVICES/'
                                 || l_service_id
                                 || l_extension;
                drive_crud_api.set_bucket(app_config.g_default_bucket);
                drive_crud_api.upload_file(
                    p_parent_name => 'FAST_TRACK_SERVICES',
                    p_filename    => l_service_id || l_extension,
                    p_blob        => l_blob
                );

                l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                || drive_crud_api.create_par(
                    p_object_name  => l_object_name,
                    p_par_name     => 'ftserv-'
                                  || l_service_id
                                  || '-par',
                    p_time_expires => add_months(systimestamp, 12)
                );

                update fast_track_service_catalog
                set
                    service_pic_url = l_public_url,
                    service_pic_filename = l_filename,
                    service_pic_lastupd = sysdate,
                    updated = systimestamp,
                    updated_by = p_created_by
                where
                    service_id = l_service_id;

            exception
                when no_data_found then
                    null; -- ✅ زي add_car_type: تجاهل
            end;
        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20024, 'Fast track service creation failed: ' || sqlerrm);
    end add_fast_track_service;

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
        p_service_pic      in varchar2 default null  -- APEX temp file name
    ) is

        l_blob        blob;
        l_filename    varchar2(512);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
        l_old_url     varchar2(4000);
    begin
      -- 1) Update main fields
        update fast_track_service_catalog
        set
            service_name = p_service_name,
            service_desc = p_service_desc,
            active = nvl(p_active, 'Y'),
            default_price = p_default_price,
            default_currency = nvl(p_default_currency, 'EGP'),
            is_per_person = nvl(p_is_per_person, 'Y'),
            is_vat_included = nvl(p_is_vat_included, 'N'),
            updated = systimestamp,
            updated_by = p_updated_by
        where
            service_id = p_service_id;

        if sql%rowcount = 0 then
            raise_application_error(-20022, 'Fast track service not found.');
        end if;

      -- 2) Replace picture if provided
        if trim(p_service_pic) is not null then

        -- (optional) try delete old object
            begin
                select
                    service_pic_url
                into l_old_url
                from
                    fast_track_service_catalog
                where
                    service_id = p_service_id;

                if l_old_url is not null then
                    l_object_name := regexp_substr(l_old_url, 'FAST_TRACK_SERVICES/[^?]+');
                    if l_object_name is not null then
                        drive_crud_api.set_bucket(app_config.g_default_bucket);
                        begin
                            drive_crud_api.delete_file(l_object_name);
                        exception
                            when others then
                                null;
                        end;
                    end if;

                end if;

            exception
                when no_data_found then
                    null;
            end;

        -- upload new
            begin
                select
                    blob_content,
                    filename
                into
                    l_blob,
                    l_filename
                from
                    apex_application_temp_files
                where
                    name = trim(p_service_pic);

                l_extension := lower(nvl(
                    regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                    '.jpg'
                ));
                l_object_name := 'FAST_TRACK_SERVICES/'
                                 || p_service_id
                                 || l_extension;
                drive_crud_api.set_bucket(app_config.g_default_bucket);
                drive_crud_api.upload_file(
                    p_parent_name => 'FAST_TRACK_SERVICES',
                    p_filename    => p_service_id || l_extension,
                    p_blob        => l_blob
                );

                l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                                || drive_crud_api.create_par(
                    p_object_name  => l_object_name,
                    p_par_name     => 'ftserv-'
                                  || p_service_id
                                  || '-par',
                    p_time_expires => add_months(systimestamp, 12)
                );

                update fast_track_service_catalog
                set
                    service_pic_url = l_public_url,
                    service_pic_filename = l_filename,
                    service_pic_lastupd = sysdate,
                    updated = systimestamp,
                    updated_by = p_updated_by
                where
                    service_id = p_service_id;

            exception
                when no_data_found then
                    null;
            end;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20023, 'Fast track service update failed: ' || sqlerrm);
    end update_fast_track_service;

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
    ) is

        l_id          varchar2(50);
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
    begin
        insert into suppliers (
            supplier_name,
            is_company,
            supplier_type_id,
            national_id,
            tax_id,
            phone,
            email,
            address,
            city,
            country_id,
            notes,
            company_reg_no,
            contact_person,
            has_portal_access,
            username,
            password_hash,
            status
        ) values ( p_supplier_name,
                   p_is_company,
                   p_supplier_type_id,
                   p_national_id,
                   p_tax_id,
                   p_phone,
                   p_email,
                   p_address,
                   p_city,
                   p_country_id,
                   p_notes,
                   p_company_reg_no,
                   p_contact_person,
                   p_has_portal_access,
                   p_username,
                   p_password_hash,
                   p_status ) returning supplier_id into l_id;

        if p_profile_photo is not null then
            select
                blob_content,
                filename
            into
                l_blob,
                l_filename
            from
                apex_application_temp_files
            where
                name = p_profile_photo;

            l_extension := lower(nvl(
                regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                '.jpg'
            ));
            l_object_name := 'SUPPLIERS_AVATAR/'
                             || l_id
                             || l_extension;
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.upload_file(
                p_parent_name => 'SUPPLIERS_AVATAR',
                p_filename    => l_id || l_extension,
                p_blob        => l_blob
            );

            l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                            || drive_crud_api.create_par(
                p_object_name  => l_object_name,
                p_par_name     => 'supplier-'
                              || l_id
                              || '-par',
                p_time_expires => add_months(systimestamp, 12)
            );

            update suppliers
            set
                photo_url = l_public_url,
                photo_last_updated = systimestamp
            where
                supplier_id = l_id;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20002, 'Supplier insert failed: ' || sqlerrm);
    end insert_supplier;

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
    ) is

        l_old_url     varchar2(2000);
        l_old_object  varchar2(400);
        l_blob        blob;
        l_filename    varchar2(255);
        l_extension   varchar2(20);
        l_object_name varchar2(400);
        l_public_url  varchar2(4000);
    begin
        update suppliers
        set
            supplier_name = p_supplier_name,
            is_company = p_is_company,
            supplier_type_id = p_supplier_type_id,
            national_id = p_national_id,
            tax_id = p_tax_id,
            phone = p_phone,
            email = p_email,
            address = p_address,
            city = p_city,
            country_id = p_country_id,
            notes = p_notes,
            company_reg_no = p_company_reg_no,
            contact_person = p_contact_person,
            has_portal_access = p_has_portal_access,
            username = p_username,
            password_hash = p_password_hash,
            status = p_status
        where
            supplier_id = p_supplier_id;

        if p_profile_photo is not null then
            select
                photo_url
            into l_old_url
            from
                suppliers
            where
                supplier_id = p_supplier_id;

            if l_old_url is not null then
                l_old_object := regexp_substr(l_old_url, 'SUPPLIERS_AVATAR/.*$');
                if l_old_object is not null then
                    drive_crud_api.set_bucket(app_config.g_default_bucket);
                    drive_crud_api.delete_file(l_old_object);
                end if;

            end if;

            select
                blob_content,
                filename
            into
                l_blob,
                l_filename
            from
                apex_application_temp_files
            where
                name = p_profile_photo;

            l_extension := lower(nvl(
                regexp_substr(l_filename, '\.[[:alnum:]]+$'),
                '.jpg'
            ));
            l_object_name := 'SUPPLIERS_AVATAR/'
                             || p_supplier_id
                             || l_extension;
            drive_crud_api.set_bucket(app_config.g_default_bucket);
            drive_crud_api.upload_file(
                p_parent_name => 'SUPPLIERS_AVATAR',
                p_filename    => p_supplier_id || l_extension,
                p_blob        => l_blob
            );

            l_public_url := 'https://objectstorage.me-jeddah-1.oraclecloud.com'
                            || drive_crud_api.create_par(
                p_object_name  => l_object_name,
                p_par_name     => 'supplier-'
                              || p_supplier_id
                              || '-par',
                p_time_expires => add_months(systimestamp, 12)
            );

            update suppliers
            set
                photo_url = l_public_url,
                photo_last_updated = systimestamp
            where
                supplier_id = p_supplier_id;

        end if;

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20003, 'Supplier update failed: ' || sqlerrm);
    end update_supplier;

    procedure delete_supplier (
        p_supplier_id in suppliers.supplier_id%type
    ) is
        l_photo_url   varchar2(2000);
        l_object_name varchar2(400);
    begin
        select
            photo_url
        into l_photo_url
        from
            suppliers
        where
            supplier_id = p_supplier_id;

        if l_photo_url is not null then
            l_object_name := regexp_substr(l_photo_url, 'SUPPLIERS_AVATAR/[^?]+');
            if l_object_name is not null then
                drive_crud_api.set_bucket(app_config.g_default_bucket);
                begin
                    drive_crud_api.delete_file(l_object_name);
                exception
                    when others then
                        null; -- استمر حتى لو حذف الملف فشل
                end;
            end if;

        end if;

        delete from suppliers
        where
            supplier_id = p_supplier_id;

        commit;
    exception
        when no_data_found then
            raise_application_error(-20003, 'Supplier not found.');
        when others then
            rollback;
            raise_application_error(-20004, 'Delete supplier failed: ' || sqlerrm);
    end delete_supplier;

end all_views_pkg;
/

