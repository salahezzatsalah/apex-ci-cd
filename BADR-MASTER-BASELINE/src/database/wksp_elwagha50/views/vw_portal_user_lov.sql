create or replace force editionable view vw_portal_user_lov (
    return_value,
    display_value,
    name,
    user_type
) as
    select
        e.id           as return_value,
        e.first_name
        || ' '
        || e.last_name
        || ' (موظف)'   as display_value,
        e.first_name
        || ' '
        || e.last_name as name,
        'EMPLOYEE'     as user_type
    from
        bs_employees e
    union all
    select
        d.driver_id,
        d.driver_name || ' (سائق شركة)',
        d.driver_name,
        'DRIVER'
    from
        company_drivers d
    union all
    select
        to_char(s.supplier_id),
        s.supplier_name || ' (مورد خارج)',
        s.supplier_name,
        'SUPPLIER'
    from
        suppliers s;


-- sqlcl_snapshot {"hash":"6b9e3c23b45b7e91078a03ba7154451d5eccc333","type":"VIEW","name":"VW_PORTAL_USER_LOV","schemaName":"WKSP_ELWAGHA50","sxml":""}