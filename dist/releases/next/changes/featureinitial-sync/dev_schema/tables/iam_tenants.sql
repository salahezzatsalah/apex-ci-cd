-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463966925 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_tenants.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_tenants.sql:null:686e23cd12fed566d6d6c306555c64a2ac18eaf5:create

create table iam_tenants (
    tenant_id   varchar2(32 byte) default lower(rawtohex(sys_guid())),
    tenant_code varchar2(50 byte),
    tenant_name varchar2(150 byte),
    status      varchar2(20 byte) default 'ACTIVE',
    created     timestamp(6) with time zone default systimestamp,
    updated     timestamp(6) with time zone
);

create unique index pk_iam_tenants on
    iam_tenants (
        tenant_id
    );

alter table iam_tenants
    add constraint pk_iam_tenants primary key ( tenant_id )
        using index pk_iam_tenants enable;

