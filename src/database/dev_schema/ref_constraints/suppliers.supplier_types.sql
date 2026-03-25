alter table suppliers
    add
        foreign key ( supplier_type_id )
            references supplier_types ( supplier_type_id )
        enable;


-- sqlcl_snapshot {"hash":"2bfb2c768af9a29cb92988124f4d22a3396ebfdb","type":"REF_CONSTRAINT","name":"SUPPLIERS.SUPPLIER_TYPES","schemaName":"DEV_SCHEMA","sxml":""}