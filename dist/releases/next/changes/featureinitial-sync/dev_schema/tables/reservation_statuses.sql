-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464028339 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\reservation_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/reservation_statuses.sql:null:963cd8305e6e963e93030a6b8f3e6cf62e028181:create

create table reservation_statuses (
    status_code        varchar2(30 byte),
    status_label_ar    varchar2(100 byte),
    status_label_en    varchar2(100 byte),
    status_color       varchar2(30 byte),
    status_badge_class varchar2(50 byte),
    status_order       number,
    is_active          char(1 byte) default 'Y',
    created_at         date default sysdate
);

create unique index pk_res_statuses on
    reservation_statuses (
        status_code
    );

alter table reservation_statuses
    add constraint pk_res_statuses primary key ( status_code )
        using index pk_res_statuses enable;

