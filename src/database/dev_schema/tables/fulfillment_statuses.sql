create table fulfillment_statuses (
    status_code varchar2(30 byte),
    label_en    varchar2(100 byte),
    label_ar    varchar2(100 byte),
    stage       number(3, 0),
    is_final    char(1 byte) default 'N',
    created_at  date default sysdate,
    created_by  varchar2(200 byte)
);

create unique index pk_fulfillment_statuses on
    fulfillment_statuses (
        status_code
    );

alter table fulfillment_statuses
    add constraint pk_fulfillment_statuses primary key ( status_code )
        using index pk_fulfillment_statuses enable;


-- sqlcl_snapshot {"hash":"6d044075d2b7b66205c0435b025a34bf7fa08c69","type":"TABLE","name":"FULFILLMENT_STATUSES","schemaName":"DEV_SCHEMA","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>FULFILLMENT_STATUSES</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS_CODE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LABEL_EN</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LABEL_AR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>3</PRECISION>\n            <SCALE>0</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IS_FINAL</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'N'</DEFAULT>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_AT</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>SYSDATE</DEFAULT>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>200</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_FULFILLMENT_STATUSES</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>STATUS_CODE</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}