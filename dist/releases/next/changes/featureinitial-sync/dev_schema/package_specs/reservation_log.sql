-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463886713 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\reservation_log.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/reservation_log.sql:null:b4829af8f4428e9676aafe4c2a1a60616c400191:create

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

