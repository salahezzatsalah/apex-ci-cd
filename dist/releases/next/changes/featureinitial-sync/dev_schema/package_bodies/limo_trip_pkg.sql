-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463864605 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\limo_trip_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/limo_trip_pkg.sql:null:3b51cc3240ce6387f525bfd12b50574446ab2925:create

create or replace package body limo_trip_pkg as

    procedure start_trip (
        p_product_id    in varchar2,  -- still PRODUCT_ID from UI
        p_assignment_id in varchar2,
        p_driver_id     in varchar2,
        p_used_car_id   in varchar2,
        p_executed_day  in date,
        p_created_by    in varchar2,
        p_trip_id       out varchar2
    ) is
        v_car_type   varchar2(200);
        v_sub_res_id varchar2(50);
    begin
    /* =====================================================
       0) Resolve SUB_RES_ID from assignment (SOURCE OF TRUTH)
       ===================================================== */
        begin
            select
                product_id
            into v_sub_res_id
            from
                limo_product_assignments
            where
                assignment_id = p_assignment_id;

        exception
            when no_data_found then
                raise_application_error(-20001, 'Invalid ASSIGNMENT_ID – cannot resolve SUB_RES_ID');
        end;

    /* =====================================================
       1) Validate SUBLEVEL_LIMO_RES
       ===================================================== */
        begin
            select
                1
            into v_car_type
            from
                sublevel_limo_res
            where
                    sub_res_id = v_sub_res_id
                and nvl(is_deleted, 'N') = 'N';

        exception
            when no_data_found then
                raise_application_error(-20002, 'SUB_RES_ID not found or deleted: ' || v_sub_res_id);
        end;

    /* =====================================================
       2) Generate Trip ID
       ===================================================== */
        p_trip_id := 'TRIP-' || to_char(systimestamp, 'YYYYMMDDHH24MISSFF3');

    /* =====================================================
       3) Resolve car display
       ===================================================== */
        begin
            select
                car_name
                || ' - '
                || license_plate
                || ' - '
                || year
            into v_car_type
            from
                company_registered_cars
            where
                id = p_used_car_id;

        exception
            when no_data_found then
                v_car_type := null;
        end;

    /* =====================================================
       4) Insert trip
       ===================================================== */
        insert into limo_trips_tracker_v2 (
            trip_id,
            product_id,      -- stores SUB_RES_ID
            assignment_id,
            driver_id,
            status,
            created_by,
            created,
            start_datetime,
            used_car_id,
            used_car_type,
            executed_date
        ) values ( p_trip_id,
                   v_sub_res_id,
                   p_assignment_id,
                   p_driver_id,
                   'ACTIVE',
                   nvl(p_created_by, user),
                   systimestamp,
                   systimestamp,
                   p_used_car_id,
                   v_car_type,
                   trunc(p_executed_day) );

    /* =====================================================
       5) Accounting
       ===================================================== */
        recalc_trip_accounting_v2(p_trip_id);
    end start_trip;

end limo_trip_pkg;
/

