-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463884090 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\ops_sync_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/ops_sync_pkg.sql:null:ed1626e14ea5e3fe507e0c786b92681b5886fada:create

create or replace package ops_sync_pkg as

  /* Sync one order item */
    procedure sync_item (
        p_order_item_id in varchar2
    );

  /* Sync all items of one main order */
    procedure sync_main (
        p_main_res_id in varchar2
    );

  /* Full rebuild */
    procedure sync_all;

  /* Process retry queue (used by job) */
    procedure process_queue;

end ops_sync_pkg;
/

