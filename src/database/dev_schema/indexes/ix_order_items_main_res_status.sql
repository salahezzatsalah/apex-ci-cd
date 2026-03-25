create index ix_order_items_main_res_status on
    order_items (
        main_res_id,
        fulfillment_status
    );


-- sqlcl_snapshot {"hash":"3220dbcfb28dbf6cf407203a6e693d546135da68","type":"INDEX","name":"IX_ORDER_ITEMS_MAIN_RES_STATUS","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IX_ORDER_ITEMS_MAIN_RES_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>ORDER_ITEMS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MAIN_RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FULFILLMENT_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}