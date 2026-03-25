create index ix_ooc_assigned on
    ops_orders_current (
        assigned_to_name
    );


-- sqlcl_snapshot {"hash":"3eb56b3f3de7c311a2f0d25befd901e1b2ace21c","type":"INDEX","name":"IX_OOC_ASSIGNED","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_OOC_ASSIGNED</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>OPS_ORDERS_CURRENT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ASSIGNED_TO_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}