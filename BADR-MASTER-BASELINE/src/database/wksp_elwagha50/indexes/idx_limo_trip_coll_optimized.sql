create index idx_limo_trip_coll_optimized on
    limo_trip_collections (
        collected_by_type,
        collected_by_id,
        currency,
        trip_id
    );


-- sqlcl_snapshot {"hash":"fbbbac507ee501b1aeb1232ca97d6fa444b0d973","type":"INDEX","name":"IDX_LIMO_TRIP_COLL_OPTIMIZED","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IDX_LIMO_TRIP_COLL_OPTIMIZED</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>LIMO_TRIP_COLLECTIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>COLLECTED_BY_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>COLLECTED_BY_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CURRENCY</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TRIP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}