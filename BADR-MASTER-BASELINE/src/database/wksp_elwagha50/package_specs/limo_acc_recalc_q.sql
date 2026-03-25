create or replace package limo_acc_recalc_q as
    procedure add_trip (
        p_trip_id in varchar2
    );

    procedure add_assignment (
        p_assignment_id in varchar2
    );

    procedure flush;

end limo_acc_recalc_q;
/


-- sqlcl_snapshot {"hash":"8dcf91fa646db533294a74a289f8b6088c970867","type":"PACKAGE_SPEC","name":"LIMO_ACC_RECALC_Q","schemaName":"WKSP_ELWAGHA50","sxml":""}