create index idx_limo_coll_trip on
    limo_trip_collections (
        trip_id
    );


-- sqlcl_snapshot {"hash":"25b1532d9f0634f200bc57204d095bc63ec3fb0a","type":"INDEX","name":"IDX_LIMO_COLL_TRIP","schemaName":"DEV_SCHEMA","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IDX_LIMO_COLL_TRIP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DEV_SCHEMA</SCHEMA>\n         <NAME>LIMO_TRIP_COLLECTIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TRIP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}