-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463887535 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\utility_fulfillment.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/utility_fulfillment.sql:null:2dbaced813fd1982f2722f7d0beacbf3f02249fa:create

create or replace package utility_fulfillment as

  /* Change one item status + log history + update parent order */
    procedure set_item_status (
        p_order_item_id in order_items.order_item_id%type,
        p_new_status    in fulfillment_statuses.status_code%type,
        p_changed_by    in varchar2,
        p_notes         in varchar2 default null
    );

  /* Recalculate order status from its items */
    procedure recalc_order_status (
        p_main_res_id in main_reservations.main_res_id%type,
        p_changed_by  in varchar2 default null
    );

end utility_fulfillment;
/

