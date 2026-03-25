-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463931658 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\billing_groups.sql
-- sqlcl_snapshot src/database/dev_schema/tables/billing_groups.sql:null:b45567c7160ddfedb26516481f91896cd12609c3:create

create table billing_groups (
    billing_group_id varchar2(30 byte),
    customer_id      varchar2(36 byte),
    group_title      varchar2(255 byte),
    status           varchar2(20 byte),
    currency_code    varchar2(10 byte),
    created_at       date default sysdate,
    created_by       varchar2(50 byte)
);

alter table billing_groups add primary key ( billing_group_id )
    using index enable;

