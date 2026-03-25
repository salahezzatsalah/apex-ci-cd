-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464027198 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\reservation_interactions_log.sql
-- sqlcl_snapshot src/database/dev_schema/tables/reservation_interactions_log.sql:null:a374e09b3adbf26e772643b774b993a27e430cfc:create

create table reservation_interactions_log (
    id               number default on null to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    reservation_id   varchar2(50 byte),
    app_page         number,
    user_id          varchar2(50 char),
    action           varchar2(50 char),
    page_rendered    timestamp(6) with time zone,
    reservation_type varchar2(20 char)
);

create unique index res_interactions_log_pk on
    reservation_interactions_log (
        id
    );

alter table reservation_interactions_log
    add constraint res_interactions_log_pk primary key ( id )
        using index res_interactions_log_pk enable;

