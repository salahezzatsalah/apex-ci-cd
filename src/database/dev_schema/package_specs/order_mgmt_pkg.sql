create or replace package order_mgmt_pkg as
    function get_or_create_active_order (
        p_customer_id in varchar2,
        p_currency    in varchar2 default 'EGP'
    ) return varchar2;

    procedure assert_order_is_active (
        p_main_res_id in varchar2
    );

    procedure add_item (
        p_main_res_id   in varchar2,
        p_item_type     in varchar2,
        p_ref_table     in varchar2,
        p_ref_id        in varchar2,
        p_item_status   in varchar2,
        p_amount_orig   in number,
        p_currency      in varchar2,
        p_exchange_rate in number,
        p_source        in varchar2 default 'WEB',
        o_order_item_id out varchar2,
        o_created_at    out timestamp,
        o_created_by    out varchar2
    );

    procedure update_item (
        p_item_type     in varchar2,
        p_ref_id        in varchar2,
        p_item_status   in varchar2,
        p_amount_orig   in number,
        p_currency      in varchar2,
        p_exchange_rate in number,
        o_updated_at    out timestamp,
        o_updated_by    out varchar2
    );

    procedure cancel_item (
        p_item_type  in varchar2,
        p_ref_id     in varchar2,
        o_updated_at out timestamp,
        o_updated_by out varchar2
    );

    procedure complete_order (
        p_main_res_id in varchar2,
        p_user_id     in varchar2
    );

    procedure set_item_snapshot (
        p_order_item_id       in varchar2,
        p_display_title_ar    in varchar2,
        p_display_subtitle_ar in varchar2 default null,
        p_service_start_ts    in timestamp default null,
        p_service_end_ts      in timestamp default null,
        p_assigned_to_emp_id  in number default null,
        p_assigned_to_name    in varchar2 default null,
        p_meta_json           in clob default null
    );

  /* =========================
     ✅ Payment lifecycle
     ========================= */

    procedure assert_order_is_payable (
        p_main_res_id in varchar2
    );

    procedure initiate_checkout (
        p_main_res_id in varchar2,
        p_provider    in varchar2,
        p_payment_ref in varchar2,
        p_user_id     in varchar2
    );

    procedure confirm_payment (
        p_main_res_id in varchar2,
        p_provider    in varchar2,
        p_payment_ref in varchar2,
        p_user_id     in varchar2
    );

    procedure fail_payment (
        p_main_res_id in varchar2,
        p_provider    in varchar2,
        p_payment_ref in varchar2,
        p_reason      in varchar2,
        p_user_id     in varchar2
    );

    procedure expire_stale_carts (
        p_hours_old in number default 6
    );

end order_mgmt_pkg;
/


-- sqlcl_snapshot {"hash":"33723bdfae418d4d4ff09904d56c35ee87c469e6","type":"PACKAGE_SPEC","name":"ORDER_MGMT_PKG","schemaName":"DEV_SCHEMA","sxml":""}