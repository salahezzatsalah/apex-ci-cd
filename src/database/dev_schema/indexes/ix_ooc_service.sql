create index ix_ooc_service on
    ops_orders_current (
        ref_table
    );


-- sqlcl_snapshot {"hash":"a9759b64174d6eb8f23db8a1f4ee4ffc458df4d7","type":"INDEX","name":"IX_OOC_SERVICE","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IX_OOC_SERVICE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>OPS_ORDERS_CURRENT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REF_TABLE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}