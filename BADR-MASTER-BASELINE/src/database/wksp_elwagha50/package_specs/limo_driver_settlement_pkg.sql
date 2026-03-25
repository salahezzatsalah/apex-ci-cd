create or replace package limo_driver_settlement_pkg as
    procedure create_driver_settlement (
        p_driver_id     in varchar2,
        p_settlement_id out varchar2
    );

end limo_driver_settlement_pkg;
/


-- sqlcl_snapshot {"hash":"b9256954e859f5b490d9e1a7c00232224acfe39b","type":"PACKAGE_SPEC","name":"LIMO_DRIVER_SETTLEMENT_PKG","schemaName":"WKSP_ELWAGHA50","sxml":""}