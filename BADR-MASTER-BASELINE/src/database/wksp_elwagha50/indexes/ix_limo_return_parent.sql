create index ix_limo_return_parent on
    sublevel_limo_res (
        parent_sub_res_id
    );


-- sqlcl_snapshot {"hash":"f8191a83c559a1dc37e10e18998ad65003420907","type":"INDEX","name":"IX_LIMO_RETURN_PARENT","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_LIMO_RETURN_PARENT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>SUBLEVEL_LIMO_RES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PARENT_SUB_RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}