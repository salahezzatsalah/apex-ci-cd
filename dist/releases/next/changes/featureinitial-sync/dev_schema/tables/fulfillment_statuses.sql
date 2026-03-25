-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463959658 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\fulfillment_statuses.sql
-- sqlcl_snapshot src/database/dev_schema/tables/fulfillment_statuses.sql:null:6d258bc240b7c07a16dda4326e9022ceec304ab8:create

create table fulfillment_statuses (
    status_code varchar2(30 byte),
    label_en    varchar2(100 byte),
    label_ar    varchar2(100 byte),
    stage       number(3, 0),
    is_final    char(1 byte) default 'N',
    created_at  date default sysdate,
    created_by  varchar2(200 byte)
);

create unique index pk_fulfillment_statuses on
    fulfillment_statuses (
        status_code
    );

alter table fulfillment_statuses
    add constraint pk_fulfillment_statuses primary key ( status_code )
        using index pk_fulfillment_statuses enable;

