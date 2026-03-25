create or replace force editionable view v_account_owners (
    owner_type,
    owner_id,
    owner_name
) as
    select
        'Employee'   as owner_type,
        id           as owner_id,
        first_name
        || ' '
        || last_name as owner_name
    from
        bs_employees
    union all
    select
        'Supplier',
        supplier_id,
        supplier_name
    from
        suppliers
    union all
    select
        'Driver',
        driver_id,
        driver_name
    from
        company_drivers
    union all
    select
        'Company',
        'COMPANY',
        'الشركة' as owner_name
    from
        dual;


-- sqlcl_snapshot {"hash":"80915f2ae62b1418b9be01607b6021db94d660de","type":"VIEW","name":"V_ACCOUNT_OWNERS","schemaName":"DEV_SCHEMA","sxml":""}