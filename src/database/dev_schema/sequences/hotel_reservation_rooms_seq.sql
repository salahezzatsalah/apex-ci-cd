create sequence hotel_reservation_rooms_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ nocache
noorder nocycle nokeep noscale global;


-- sqlcl_snapshot {"hash":"884e6900f32ffaac39bf4f758c224c77fef830fc","type":"SEQUENCE","name":"HOTEL_RESERVATION_ROOMS_SEQ","schemaName":"DEV_SCHEMA","sxml":"\n  <SEQUENCE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DEV_SCHEMA</SCHEMA>\n   <NAME>HOTEL_RESERVATION_ROOMS_SEQ</NAME>\n   \n   <INCREMENT>1</INCREMENT>\n   <MINVALUE>1</MINVALUE>\n   <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n   <CACHE>0</CACHE>\n   <SCALE>NOSCALE</SCALE>\n</SEQUENCE>"}