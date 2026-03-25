create or replace package utility_invoice as
    function get_invoice_id (
        p_main_res_id in varchar2
    ) return varchar2;

    procedure create_invoice (
        p_main_res_id in varchar2,
        p_created_by  in varchar2
    );

    procedure refresh_invoice (
        p_main_res_id in varchar2
    );

    procedure apply_promo (
        p_main_res_id   in varchar2,
        p_discount_type in varchar2, -- PERCENT / FIXED
        p_value         in number,
        p_created_by    in varchar2
    );

    procedure remove_promos (
        p_main_res_id in varchar2
    );

    procedure issue_invoice (
        p_main_res_id in varchar2
    );

end utility_invoice;
/


-- sqlcl_snapshot {"hash":"b30544381d1a3888c9476097a65e902abd9c1b6b","type":"PACKAGE_SPEC","name":"UTILITY_INVOICE","schemaName":"WKSP_ELWAGHA50","sxml":""}