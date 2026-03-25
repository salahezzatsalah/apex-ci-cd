create sequence limo_reservation_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache noorder
nocycle nokeep noscale global;


-- sqlcl_snapshot {"hash":"d8fbc1c256eb52dc8d26ccaf7756351f0303b959","type":"SEQUENCE","name":"LIMO_RESERVATION_SEQ","schemaName":"DEV_SCHEMA","sxml":"\n  <SEQUENCE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>LIMO_RESERVATION_SEQ</NAME>\n   \n   <INCREMENT>1</INCREMENT>\n   <MINVALUE>1</MINVALUE>\n   <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n   <CACHE>0</CACHE>\n   <SCALE>NOSCALE</SCALE>\n</SEQUENCE>"}