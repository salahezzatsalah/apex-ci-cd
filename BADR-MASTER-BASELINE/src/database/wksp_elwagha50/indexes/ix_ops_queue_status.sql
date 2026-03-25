create index ix_ops_queue_status on
    ops_sync_queue (
        status,
        next_run_at
    );


-- sqlcl_snapshot {"hash":"8e6dc7203f26d63ea682c3a4e0c13d2a69b3c785","type":"INDEX","name":"IX_OPS_QUEUE_STATUS","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_OPS_QUEUE_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>OPS_SYNC_QUEUE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NEXT_RUN_AT</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}