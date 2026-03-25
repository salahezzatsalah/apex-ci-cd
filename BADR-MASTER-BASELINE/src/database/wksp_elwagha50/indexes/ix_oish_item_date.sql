create index ix_oish_item_date on
    order_item_status_history (
        order_item_id,
        changed_at
    desc );


-- sqlcl_snapshot {"hash":"c5e65accb2a9b73750a26dbcf22af4d718d37e29","type":"INDEX","name":"IX_OISH_ITEM_DATE","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_OISH_ITEM_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>ORDER_ITEM_STATUS_HISTORY</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_ITEM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>\"CHANGED_AT\"</DEFAULT_EXPRESSION>\n            <DESC></DESC>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}