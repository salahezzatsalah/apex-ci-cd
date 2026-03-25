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


-- sqlcl_snapshot {"hash":"ed1626e14ea5e3fe507e0c786b92681b5886fada","type":"PACKAGE_SPEC","name":"OPS_SYNC_PKG","schemaName":"WKSP_ELWAGHA50","sxml":""}