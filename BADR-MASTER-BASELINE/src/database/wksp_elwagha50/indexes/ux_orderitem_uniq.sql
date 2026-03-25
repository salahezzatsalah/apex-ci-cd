create unique index ux_orderitem_uniq on
    order_items (
        item_type,
        ref_id
    );


-- sqlcl_snapshot {"hash":"c5218182037a4c41da14ef3de128f72b63995ff6","type":"INDEX","name":"UX_ORDERITEM_UNIQ","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>UX_ORDERITEM_UNIQ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>ORDER_ITEMS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ITEM_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}