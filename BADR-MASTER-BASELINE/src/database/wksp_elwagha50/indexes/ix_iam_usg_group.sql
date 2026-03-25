create index ix_iam_usg_group on
    iam_user_security_groups (
        group_id
    );


-- sqlcl_snapshot {"hash":"7c0cf7aab9e46ce29a69e6bf32e547af853df55e","type":"INDEX","name":"IX_IAM_USG_GROUP","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>IX_IAM_USG_GROUP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n         <NAME>IAM_USER_SECURITY_GROUPS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>GROUP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}