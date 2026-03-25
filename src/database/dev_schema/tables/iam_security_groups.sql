create table iam_security_groups (
    group_id     varchar2(32 byte) default lower(rawtohex(sys_guid())),
    group_code   varchar2(80 byte),
    group_name   varchar2(150 byte),
    description  varchar2(500 byte),
    is_active_yn varchar2(1 byte) default 'Y',
    created      timestamp(6) with time zone default systimestamp
);

create unique index pk_iam_security_groups on
    iam_security_groups (
        group_id
    );

alter table iam_security_groups
    add constraint pk_iam_security_groups primary key ( group_id )
        using index pk_iam_security_groups enable;


-- sqlcl_snapshot {"hash":"64c088ae94c4b9f366d1d9575e7dc9f71916b03a","type":"TABLE","name":"IAM_SECURITY_GROUPS","schemaName":"DEV_SCHEMA","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>IAM_SECURITY_GROUPS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>GROUP_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>32</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>LOWER(RAWTOHEX(SYS_GUID()))</DEFAULT>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GROUP_CODE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>80</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GROUP_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>150</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DESCRIPTION</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>500</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IS_ACTIVE_YN</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'Y'</DEFAULT>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED</NAME>\n            <DATATYPE>TIMESTAMP_WITH_TIMEZONE</DATATYPE>\n            <SCALE>6</SCALE>\n            <DEFAULT>SYSTIMESTAMP</DEFAULT>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_IAM_SECURITY_GROUPS</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>GROUP_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}