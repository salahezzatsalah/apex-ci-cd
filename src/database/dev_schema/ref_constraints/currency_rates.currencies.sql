alter table currency_rates
    add
        foreign key ( currency_code )
            references currencies ( currency_code )
        enable;


-- sqlcl_snapshot {"hash":"f6bed39d54013b1a4440aa8e20f706f498d16e4c","type":"REF_CONSTRAINT","name":"CURRENCY_RATES.CURRENCIES","schemaName":"DEV_SCHEMA","sxml":""}