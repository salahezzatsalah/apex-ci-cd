-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463963681 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_organizations.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_organizations.sql:null:f986a3bff9e92016cec590c3f3fe7e98cedb044f:create

create table iam_organizations (
    party_id        varchar2(32 byte),
    legal_name      varchar2(300 byte),
    trade_name      varchar2(300 byte),
    registration_no varchar2(100 byte),
    tax_number      varchar2(100 byte),
    country         varchar2(100 byte),
    email           varchar2(255 byte),
    phone_number    varchar2(50 byte)
);

alter table iam_organizations add primary key ( party_id )
    using index enable;

