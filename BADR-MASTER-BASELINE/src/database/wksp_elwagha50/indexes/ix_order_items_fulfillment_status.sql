create index ix_order_items_fulfillment_status on
    order_items (
        fulfillment_status
    );


-- sqlcl_snapshot {"hash":"7d02a8b06da0af1c6a55ce5c8c266700ee2d8c3b","type":"INDEX","name":"IX_ORDER_ITEMS_FULFILLMENT_STATUS","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_ORDER_ITEMS_FULFILLMENT_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>ORDER_ITEMS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FULFILLMENT_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}