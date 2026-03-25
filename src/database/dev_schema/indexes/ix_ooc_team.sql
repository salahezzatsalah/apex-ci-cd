create index ix_ooc_team on
    ops_orders_current (
        owner_team
    );


-- sqlcl_snapshot {"hash":"5d3ee8723213aa32311d79aa07aceda1178870d7","type":"INDEX","name":"IX_OOC_TEAM","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IX_OOC_TEAM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>OPS_ORDERS_CURRENT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>OWNER_TEAM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}