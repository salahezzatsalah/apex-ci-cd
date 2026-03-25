create or replace package body order_router_util as

  /* =====================================================
     Internal helper: build prepared f?p url
     ===================================================== */
    function build_url (
        p_page_no   in number,
        p_item_name in varchar2,
        p_item_val  in varchar2
    ) return varchar2 is

        v_app_id varchar2(50) := v('APP_ID');
        v_sess   varchar2(200) := v('APP_SESSION');
    begin
        if p_page_no is null
           or p_item_name is null
        or p_item_val is null then
            return null;
        end if;

        return apex_util.prepare_url('f?p='
                                     || v_app_id
                                     || ':'
                                     || p_page_no
                                     || ':'
                                     || v_sess
                                     || '::::'
                                     || p_item_name
                                     || ':' || p_item_val);

    end build_url;

  /* =====================================================
     Details URL (open service operational page)
     ===================================================== */
    function details_url (
        p_ref_table in varchar2,
        p_ref_id    in varchar2
    ) return varchar2 is
        v_ref varchar2(100) := upper(trim(p_ref_table));
    begin
        if v_ref is null
           or p_ref_id is null then
            return null;
        end if;
        if v_ref = 'SUBLEVEL_LIMO_RES' then
            return build_url(
                p_page_no   => 6001,
                p_item_name => 'P6001_PRODUCT_ID',
                p_item_val  => p_ref_id
            );

        elsif v_ref = 'SUBLEVEL_FAST_TRACK_RES' then
            return build_url(
                p_page_no   => 260,
                p_item_name => 'P260_SUB_RES_ID',
                p_item_val  => p_ref_id
            );
        elsif v_ref = 'SUBLEVEL_APARTMENT_RES' then
            return build_url(
                p_page_no   => 400,
                p_item_name => 'P400_SUB_RES_ID',
                p_item_val  => p_ref_id
            );
        else
            return null;
        end if;

    end details_url;

  /* =====================================================
     Assign URL (open assignment dialog / page)
     ===================================================== */
    function assign_url (
        p_ref_table in varchar2,
        p_ref_id    in varchar2
    ) return varchar2 is
        v_ref varchar2(100) := upper(trim(p_ref_table));
    begin
        if v_ref is null
           or p_ref_id is null then
            return null;
        end if;
        if v_ref = 'SUBLEVEL_LIMO_RES' then
            return build_url(
                p_page_no   => 363,
                p_item_name => 'P363_PRODUCT_ID',
                p_item_val  => p_ref_id
            );

        elsif v_ref = 'SUBLEVEL_FAST_TRACK_RES' then
            return build_url(
                p_page_no   => 247,
                p_item_name => 'P247_SUB_RES_ID',
                p_item_val  => p_ref_id
            );
        elsif v_ref = 'SUBLEVEL_APARTMENT_RES' then
            return build_url(
                p_page_no   => 401,
                p_item_name => 'P401_SUB_RES_ID',
                p_item_val  => p_ref_id
            );
        else
            return null;
        end if;

    end assign_url;

end order_router_util;
/


-- sqlcl_snapshot {"hash":"7c2b91988b5154c57436b19ba6e8438d472aad58","type":"PACKAGE_BODY","name":"ORDER_ROUTER_UTIL","schemaName":"WKSP_ELWAGHA50","sxml":""}