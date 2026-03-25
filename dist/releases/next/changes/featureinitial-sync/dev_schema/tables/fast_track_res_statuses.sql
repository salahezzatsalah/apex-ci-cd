-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463954155 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fast_track_res_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fast_track_res_statuses.sql:null:ee7df2cf71b1d641d8f1f1e9ad2a0e69106bbaa5:create

create table fast_track_res_statuses (
    status_code        varchar2(40 byte),
    status_label_ar    varchar2(100 byte),
    status_label_en    varchar2(100 byte),
    status_badge_class varchar2(50 byte),
    status_order       number,
    is_active          char(1 byte) default 'Y',
    created_at         date default sysdate
);

create unique index pk_fast_track_res_statuses on
    fast_track_res_statuses (
        status_code
    );

alter table fast_track_res_statuses
    add constraint pk_fast_track_res_statuses primary key ( status_code )
        using index pk_fast_track_res_statuses enable;

