create index ix_ooc_priority on
    ops_orders_current (
        priority_score
    desc );


-- sqlcl_snapshot {"hash":"c49bade70631916483018955250f59c48a5263ce","type":"INDEX","name":"IX_OOC_PRIORITY","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_OOC_PRIORITY</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>OPS_ORDERS_CURRENT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>\"PRIORITY_SCORE\"</DEFAULT_EXPRESSION>\n            <DESC></DESC>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}