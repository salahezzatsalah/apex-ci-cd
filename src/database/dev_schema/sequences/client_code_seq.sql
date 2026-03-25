create sequence client_code_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder nocycle
nokeep noscale global;


-- sqlcl_snapshot {"hash":"dc5b2512c4be6107a8a07541adc7def45f487ce8","type":"SEQUENCE","name":"CLIENT_CODE_SEQ","schemaName":"DEV_SCHEMA","sxml":"\n  <SEQUENCE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>CLIENT_CODE_SEQ</NAME>\n   \n   <INCREMENT>1</INCREMENT>\n   <MINVALUE>1</MINVALUE>\n   <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n   <CACHE>0</CACHE>\n   <SCALE>NOSCALE</SCALE>\n</SEQUENCE>"}