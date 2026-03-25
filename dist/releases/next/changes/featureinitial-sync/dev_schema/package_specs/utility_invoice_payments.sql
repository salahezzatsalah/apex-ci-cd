-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463888717 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\utility_invoice_payments.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/utility_invoice_payments.sql:null:d91fb31592b0dc4d59bfc1bac71da7163dd39651:create

create or replace package utility_invoice_payments as
    procedure post_payment (
        p_invoice_id           in invoices.invoice_id%type,
        p_payment_method       in varchar2,
        p_currency_code        in varchar2,
        p_amount_orig          in number,
        p_exchange_rate_to_inv in number default null,
        p_paid_at              in timestamp default null,
        p_received_by          in varchar2,
        p_notes                in varchar2 default null,
        p_payment_id           out invoice_payments.payment_id%type
    );

    procedure void_payment (
        p_payment_id in invoice_payments.payment_id%type,
        p_voided_by  in varchar2,
        p_reason     in varchar2 default null
    );

    function get_paid_amount (
        p_invoice_id in invoices.invoice_id%type
    ) return number;

    function get_balance_amount (
        p_invoice_id in invoices.invoice_id%type
    ) return number;

    procedure sync_invoice_payment_status (
        p_invoice_id in invoices.invoice_id%type
    );

end utility_invoice_payments;
/

