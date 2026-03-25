-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464130056 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\views\vw_emp_trip_commissions.sql
-- sqlcl_snapshot src/database/dev_schema/views/vw_emp_trip_commissions.sql:null:120dbe0c8b89f3f0f7a516a6023ca5930815f03f:create

create or replace force editionable view vw_emp_trip_commissions (
    employee_id,
    employee_name,
    trip_id,
    product_id,
    assignment_id,
    start_datetime,
    office_net_egp,
    commission_egp
) as
    select
        p.created_by                as employee_id,
        coalesce(e.screen_name, e.first_name
                                || ' '
                                || e.last_name, e.username) as employee_name,
        v.trip_id,
        v.product_id,
        v.assignment_id,
        v.start_datetime,
        nvl(v.office_net_egp, 0)    as office_net_egp,
        round(greatest(
            nvl(v.office_net_egp, 0),
            0
        ) * 0.005,
              2)                    as commission_egp
    from
             vw_limo_trip_accounting v
        join limo_products p on p.product_id = v.product_id
        left join bs_employees  e on e.id = p.created_by
    where
            extract(month from v.start_datetime) = 9
        and extract(year from v.start_datetime) = extract(year from sysdate);

