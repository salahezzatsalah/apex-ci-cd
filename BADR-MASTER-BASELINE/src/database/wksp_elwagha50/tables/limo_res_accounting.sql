create table limo_res_accounting (
    res_acc_id              varchar2(30 byte),
    sub_res_id              varchar2(30 byte),
    trips_count             number,
    total_invoice_egp       number(12, 2),
    total_invoice_curr      number(12, 2),
    total_services_egp      number(12, 2),
    total_expenses_egp      number(12, 2),
    total_revenue_after_exp number(12, 2),
    total_paid_egp          number(12, 2),
    total_paid_curr         number(12, 2),
    total_outstanding_egp   number(12, 2),
    total_outstanding_curr  number(12, 2),
    total_driver_payout_egp number(12, 2),
    total_office_net_egp    number(12, 2),
    total_office_net_curr   number(12, 2),
    last_calc_at            timestamp(6) with time zone,
    created                 timestamp(6) default systimestamp,
    created_by              varchar2(100 byte),
    updated                 timestamp(6),
    updated_by              varchar2(100 byte)
);

create unique index uk_lra_sub on
    limo_res_accounting (
        sub_res_id
    );

alter table limo_res_accounting
    add constraint uk_lra_sub unique ( sub_res_id )
        using index uk_lra_sub enable;

alter table limo_res_accounting add primary key ( res_acc_id )
    using index enable;


-- sqlcl_snapshot {"hash":"790ec46e44e6304513a13c79db9effba67696138","type":"TABLE","name":"LIMO_RES_ACCOUNTING","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>LIMO_RES_ACCOUNTING</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ACC_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SUB_RES_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>30</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TRIPS_COUNT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_INVOICE_EGP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_INVOICE_CURR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_SERVICES_EGP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_EXPENSES_EGP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_REVENUE_AFTER_EXP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_PAID_EGP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_PAID_CURR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_OUTSTANDING_EGP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_OUTSTANDING_CURR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_DRIVER_PAYOUT_EGP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_OFFICE_NET_EGP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TOTAL_OFFICE_NET_CURR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>12</PRECISION>\n            <SCALE>2</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CALC_AT</NAME>\n            <DATATYPE>TIMESTAMP_WITH_TIMEZONE</DATATYPE>\n            <SCALE>6</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED</NAME>\n            <DATATYPE>TIMESTAMP</DATATYPE>\n            <SCALE>6</SCALE>\n            <DEFAULT>SYSTIMESTAMP</DEFAULT>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED</NAME>\n            <DATATYPE>TIMESTAMP</DATATYPE>\n            <SCALE>6</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>RES_ACC_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>UK_LRA_SUB</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>SUB_RES_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}