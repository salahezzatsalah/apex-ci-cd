create sequence transactions_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle
nokeep noscale global;


-- sqlcl_snapshot {"hash":"fe15a3276b1d4034c0c078a8134b82be50194b98","type":"SEQUENCE","name":"TRANSACTIONS_SEQ","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <SEQUENCE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>TRANSACTIONS_SEQ</NAME>\n   \n   <INCREMENT>1</INCREMENT>\n   <MINVALUE>1</MINVALUE>\n   <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n   <CACHE>20</CACHE>\n   <SCALE>NOSCALE</SCALE>\n</SEQUENCE>"}