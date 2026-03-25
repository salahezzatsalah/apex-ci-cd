-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463889125 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\utility_invoice_pdf.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/utility_invoice_pdf.sql:null:df62486b8a10447a5cff550f6539e8293bc339da:create

create or replace package utility_invoice_pdf as
    function build_invoice_pdf (
        p_invoice_id in invoices.invoice_id%type
    ) return blob;

end utility_invoice_pdf;
/

