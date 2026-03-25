create index idx_limo_trip_coll_driver_curr on
    limo_trip_collections (
        collected_by_type,
        collected_by_id,
        currency
    );


-- sqlcl_snapshot {"hash":"68653773cb1845123ba3b351c6aa9baa50050f19","type":"INDEX","name":"IDX_LIMO_TRIP_COLL_DRIVER_CURR","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IDX_LIMO_TRIP_COLL_DRIVER_CURR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>LIMO_TRIP_COLLECTIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>COLLECTED_BY_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>COLLECTED_BY_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CURRENCY</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}