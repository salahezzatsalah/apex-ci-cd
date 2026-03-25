create sequence seq_trips_gps_tracker minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20 noorder
nocycle nokeep noscale global;


-- sqlcl_snapshot {"hash":"f207317fca13bd81d0ebcdf35f19f245f6e7e706","type":"SEQUENCE","name":"SEQ_TRIPS_GPS_TRACKER","schemaName":"WKSP_ELWAGHA50","sxml":"\n  <SEQUENCE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>WKSP_ELWAGHA50</SCHEMA>\n   <NAME>SEQ_TRIPS_GPS_TRACKER</NAME>\n   \n   <INCREMENT>1</INCREMENT>\n   <MINVALUE>1</MINVALUE>\n   <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n   <CACHE>20</CACHE>\n   <SCALE>NOSCALE</SCALE>\n</SEQUENCE>"}