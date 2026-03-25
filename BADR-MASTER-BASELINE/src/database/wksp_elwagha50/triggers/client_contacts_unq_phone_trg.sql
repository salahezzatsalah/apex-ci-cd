create or replace editionable trigger client_contacts_unq_phone_trg before
    insert on client_contacts
    for each row
declare
    l_existing_client_id client_contacts.client_id%type;
begin
    /* =====================================================
       Apply only for PHONE contacts
       ===================================================== */
    if :new.contact_type <> 'PHONE' then
        return;
    end if;

    /* =====================================================
       Normalize phone (digits only)
       ===================================================== */
    :new.contact_value := regexp_replace(:new.contact_value,
                                         '[^0-9]',
                                         '');
    if :new.contact_value is null then
        raise_application_error(-20001, 'رقم الهاتف غير صالح');
    end if;

    /* =====================================================
       Check if phone already exists for another client
       ===================================================== */
    begin
        select
            client_id
        into l_existing_client_id
        from
            client_contacts
        where
                contact_type = 'PHONE'
            and contact_value = :new.contact_value
            and client_id <> :new.client_id
            and rownum = 1;

        /* =================================================
           Conflict found → block insert
           ================================================= */
        raise_application_error(-20001, 'رقم الهاتف مستخدم بالفعل لعميل آخر.');
    exception
        when no_data_found then
            null; -- Safe to insert
    end;

end;
/

alter trigger client_contacts_unq_phone_trg enable;


-- sqlcl_snapshot {"hash":"469c513add907d487ed1affe8dbfefc88317de10","type":"TRIGGER","name":"CLIENT_CONTACTS_UNQ_PHONE_TRG","schemaName":"WKSP_ELWAGHA50","sxml":""}