-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463880479 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\limo_acc_recalc_q.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/limo_acc_recalc_q.sql:null:8dcf91fa646db533294a74a289f8b6088c970867:create

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

