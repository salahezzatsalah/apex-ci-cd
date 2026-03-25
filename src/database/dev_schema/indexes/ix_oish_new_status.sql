create index ix_oish_new_status on
    order_item_status_history (
        new_status
    );


-- sqlcl_snapshot {"hash":"93a028a377e25fbb4953d1f322889a29cabe1047","type":"INDEX","name":"IX_OISH_NEW_STATUS","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IX_OISH_NEW_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>ORDER_ITEM_STATUS_HISTORY</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NEW_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}