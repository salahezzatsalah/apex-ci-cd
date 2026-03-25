create or replace package utility_invoice_pdf as
    function build_invoice_pdf (
        p_invoice_id in invoices.invoice_id%type
    ) return blob;

end utility_invoice_pdf;
/


-- sqlcl_snapshot {"hash":"df62486b8a10447a5cff550f6539e8293bc339da","type":"PACKAGE_SPEC","name":"UTILITY_INVOICE_PDF","schemaName":"DEV_SCHEMA","sxml":""}