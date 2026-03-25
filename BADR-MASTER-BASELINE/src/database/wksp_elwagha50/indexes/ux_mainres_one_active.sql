create unique index ux_mainres_one_active on
    main_reservations (
        customer_id,
        case
            status
            when 'ACTIVE' then
                'ACTIVE'
        end
    );


-- sqlcl_snapshot {"hash":"0321a186cef76c1158b7da09d5b2f1a2ff484afe","type":"INDEX","name":"UX_MAINRES_ONE_ACTIVE","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>UX_MAINRES_ONE_ACTIVE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>MAIN_RESERVATIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CUSTOMER_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>CASE \"STATUS\" WHEN 'ACTIVE' THEN 'ACTIVE' END </DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}