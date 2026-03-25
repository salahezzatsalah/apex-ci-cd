-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463870475 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\utility_fulfillment.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/utility_fulfillment.sql:null:92fdfb9520293567b5bba8d4812f68d523b8059b:create

create or replace package body utility_fulfillment as

  /* ==========================================================
     PROCEDURE: set_item_status
     - Validates status
     - Updates ORDER_ITEMS
     - Logs history (optional)
     - Recalculates parent order status
     ========================================================== */
    procedure set_item_status (
        p_order_item_id in order_items.order_item_id%type,
        p_new_status    in fulfillment_statuses.status_code%type,
        p_changed_by    in varchar2,
        p_notes         in varchar2 default null
    ) is

        v_new_status  fulfillment_statuses.status_code%type := upper(trim(p_new_status));
        v_old_status  order_items.fulfillment_status%type;
        v_main_res_id order_items.main_res_id%type;
        v_exists      number;
    begin
    /* ---------- validations ---------- */
        if trim(nvl(p_order_item_id, ' ')) is null then
            raise_application_error(-20001, 'ORDER_ITEM_ID is required.');
        end if;

        if trim(nvl(v_new_status, ' ')) is null then
            raise_application_error(-20002, 'New status is required.');
        end if;

    /* status must exist */
        select
            count(*)
        into v_exists
        from
            fulfillment_statuses s
        where
            s.status_code = v_new_status;

        if v_exists = 0 then
            raise_application_error(-20003, 'Invalid fulfillment status: ' || v_new_status);
        end if;

    /* fetch old status + parent order */
        select
            fulfillment_status,
            main_res_id
        into
            v_old_status,
            v_main_res_id
        from
            order_items
        where
            order_item_id = p_order_item_id;

    /* update item status */
        update order_items
        set
            fulfillment_status = v_new_status,
            fulfillment_updated_at = systimestamp,
            fulfillment_updated_by = p_changed_by
        where
            order_item_id = p_order_item_id;

        if sql%rowcount = 0 then
            raise_application_error(-20004, 'Order item not found: ' || p_order_item_id);
        end if;

    /* ---------- optional: log history ----------
       Enable this only if you have a table for it.
       Example table: ORDER_ITEM_FULFILLMENT_HIST
    */
    /*
    INSERT INTO order_item_fulfillment_hist (
      hist_id,
      order_item_id,
      main_res_id,
      old_status,
      new_status,
      notes,
      changed_at,
      changed_by
    ) VALUES (
      TO_NUMBER(SYS_GUID(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
      p_order_item_id,
      v_main_res_id,
      v_old_status,
      v_new_status,
      p_notes,
      SYSTIMESTAMP,
      p_changed_by
    );
    */

    /* recalc parent order status */
        recalc_order_status(
            p_main_res_id => v_main_res_id,
            p_changed_by  => p_changed_by
        );
    exception
        when no_data_found then
            raise_application_error(-20004, 'Order item not found: ' || p_order_item_id);
    end set_item_status;

  /* ==========================================================
     PROCEDURE: recalc_order_status
     - Reads all active items in MAIN_RES_ID
     - Updates MAIN_RESERVATIONS.STATUS
     ========================================================== */
    procedure recalc_order_status (
        p_main_res_id in main_reservations.main_res_id%type,
        p_changed_by  in varchar2 default null
    ) is

        v_total_cnt     number := 0;
        v_new_cnt       number := 0;
        v_pending_cnt   number := 0;
        v_inprog_cnt    number := 0;
        v_completed_cnt number := 0;
        v_cancelled_cnt number := 0;
        v_failed_cnt    number := 0;
        v_final_status  main_reservations.status%type;
        v_changed_by    varchar2(200) := nvl(p_changed_by,
                                          v('APP_USER'));
    begin
        if trim(nvl(p_main_res_id, ' ')) is null then
            raise_application_error(-20005, 'MAIN_RES_ID is required.');
        end if;

    /* count item statuses */
        select
            count(*) as total_cnt,
            sum(
                case
                    when nvl(fulfillment_status, 'NEW') = 'NEW' then
                        1
                    else
                        0
                end
            )        as new_cnt,
            sum(
                case
                    when nvl(fulfillment_status, 'NEW') in('PENDING_OPS', 'CONFIRMED', 'ASSIGNED') then
                        1
                    else
                        0
                end
            )        as pending_cnt,
            sum(
                case
                    when nvl(fulfillment_status, 'NEW') = 'IN_PROGRESS' then
                        1
                    else
                        0
                end
            )        as inprog_cnt,
            sum(
                case
                    when nvl(fulfillment_status, 'NEW') = 'COMPLETED' then
                        1
                    else
                        0
                end
            )        as completed_cnt,
            sum(
                case
                    when nvl(fulfillment_status, 'NEW') = 'CANCELLED' then
                        1
                    else
                        0
                end
            )        as cancelled_cnt,
            sum(
                case
                    when nvl(fulfillment_status, 'NEW') = 'FAILED' then
                        1
                    else
                        0
                end
            )        as failed_cnt
        into
            v_total_cnt,
            v_new_cnt,
            v_pending_cnt,
            v_inprog_cnt,
            v_completed_cnt,
            v_cancelled_cnt,
            v_failed_cnt
        from
            order_items
        where
                main_res_id = p_main_res_id
            and nvl(is_cancelled, 'N') = 'N';

    /* decide parent order status */
        if v_total_cnt = 0 then
            v_final_status := 'ACTIVE';  -- empty cart/order still open
        elsif v_failed_cnt > 0 then
            v_final_status := 'FAILED';
        elsif v_completed_cnt = v_total_cnt then
            v_final_status := 'COMPLETED';
        elsif v_cancelled_cnt = v_total_cnt then
            v_final_status := 'CANCELLED';
        elsif ( v_inprog_cnt > 0 ) then
            v_final_status := 'IN_PROGRESS';
        elsif ( v_pending_cnt > 0 ) then
            v_final_status := 'PENDING_OPS';
        else
            v_final_status := 'NEW';
        end if;

        update main_reservations
        set
            status = v_final_status,
            updated = systimestamp,
            updated_by = v_changed_by
        where
            main_res_id = p_main_res_id;

    end recalc_order_status;

end utility_fulfillment;
/

