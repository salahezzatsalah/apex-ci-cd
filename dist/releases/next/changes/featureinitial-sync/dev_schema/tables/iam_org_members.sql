-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463962467 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\iam_org_members.sql
-- sqlcl_snapshot src/database/dev_schema/tables/iam_org_members.sql:null:35554b459d06230b75073dc6621c90bdda23a5ad:create

create table iam_org_members (
    org_party_id    varchar2(32 byte),
    person_party_id varchar2(32 byte),
    role_code       varchar2(50 byte),
    is_primary_yn   varchar2(1 byte) default 'N',
    created         timestamp(6) with time zone default systimestamp
);

create unique index pk_iam_org_members on
    iam_org_members (
        org_party_id,
        person_party_id
    );

alter table iam_org_members
    add constraint pk_iam_org_members
        primary key ( org_party_id,
                      person_party_id )
            using index pk_iam_org_members enable;

