create sequence prep_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder nocycle nokeep
noscale global;


-- sqlcl_snapshot {"hash":"594730e412c5dd78ce59608dc14dff33431faf40","type":"SEQUENCE","name":"PREP_SEQ","schemaName":"DEV_SCHEMA","sxml":"\n  <SEQUENCE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>PREP_SEQ</NAME>\n   \n   <INCREMENT>1</INCREMENT>\n   <MINVALUE>1</MINVALUE>\n   <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n   <CACHE>20</CACHE>\n   <SCALE>NOSCALE</SCALE>\n</SEQUENCE>"}