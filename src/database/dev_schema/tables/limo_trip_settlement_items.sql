create table limo_trip_settlement_items (
    settlement_id varchar2(50 byte),
    trip_id       varchar2(50 byte)
);

alter table limo_trip_settlement_items
    add primary key ( settlement_id,
                      trip_id )
        using index enable;


-- sqlcl_snapshot {"hash":"d2d4f1486f9638ee8be44bdb494d6867a194f75c","type":"TABLE","name":"LIMO_TRIP_SETTLEMENT_ITEMS","schemaName":"DEV_SCHEMA","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>LIMO_TRIP_SETTLEMENT_ITEMS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SETTLEMENT_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TRIP_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>SETTLEMENT_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>TRIP_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}