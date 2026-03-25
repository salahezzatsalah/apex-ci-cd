-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464025671 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\reservation_contributors.sql
-- sqlcl_snapshot src/database/dev_schema/tables/reservation_contributors.sql:null:65a7c36178d55464761d70bfba3dee6c17c63e01:create

create table reservation_contributors (
    id                number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
    reservation_id    varchar2(50 char),
    team_member_id    number,
    responsibility_id number,
    responsibility    varchar2(4000 char),
    tags              varchar2(4000 char),
    created_by        varchar2(255 char) default user,
    updated_by        varchar2(255 char) default user,
    created           timestamp(6) with time zone,
    updated           timestamp(6) with time zone
);

create unique index res_contributors_pk on
    reservation_contributors (
        id
    );

alter table reservation_contributors
    add constraint res_contributors_pk primary key ( id )
        using index res_contributors_pk enable;

