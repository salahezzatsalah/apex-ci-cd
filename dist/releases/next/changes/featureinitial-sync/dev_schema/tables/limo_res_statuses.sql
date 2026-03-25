-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463997989 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\limo_res_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/limo_res_statuses.sql:null:7b42db47d31e6ceef0366ca05aabe7a83ea81fb8:create

create table limo_res_statuses (
    status_code        varchar2(40 byte),
    status_label_ar    varchar2(100 byte),
    status_label_en    varchar2(100 byte),
    status_badge_class varchar2(50 byte),
    status_order       number,
    is_active          char(1 byte) default 'Y',
    created_at         date default sysdate
);

create unique index pk_limo_res_statuses on
    limo_res_statuses (
        status_code
    );

alter table limo_res_statuses
    add constraint pk_limo_res_statuses primary key ( status_code )
        using index pk_limo_res_statuses enable;

