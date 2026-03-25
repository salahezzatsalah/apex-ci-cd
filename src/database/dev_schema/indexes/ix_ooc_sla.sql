create index ix_ooc_sla on
    ops_orders_current (
        hours_to_service
    );


-- sqlcl_snapshot {"hash":"a5a00117ee7bb5695bc2289723f5da3addf74115","type":"INDEX","name":"IX_OOC_SLA","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IX_OOC_SLA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>OPS_ORDERS_CURRENT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>HOURS_TO_SERVICE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}