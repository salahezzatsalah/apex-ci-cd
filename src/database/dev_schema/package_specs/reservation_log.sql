create or replace package reservation_log as
    procedure log_interaction (
        p_reservation_id in varchar2,
        p_type           in varchar2
    );

    function log_and_summarize (
        p_reservation_id in varchar2,
        p_type           in varchar2
    ) return varchar2;

end reservation_log;
/


-- sqlcl_snapshot {"hash":"b4829af8f4428e9676aafe4c2a1a60616c400191","type":"PACKAGE_SPEC","name":"RESERVATION_LOG","schemaName":"DEV_SCHEMA","sxml":""}