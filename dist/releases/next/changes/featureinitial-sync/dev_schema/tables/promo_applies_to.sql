-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464022362 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\promo_applies_to.sql
-- sqlcl_snapshot src/database/dev_schema/tables/promo_applies_to.sql:null:5f6a4f105e4f4c09c6d65a27502d603cef07145c:create

create table promo_applies_to (
    promo_id  varchar2(30 byte),
    ref_table varchar2(50 byte)
);

create unique index pk_promo_applies_to on
    promo_applies_to (
        promo_id,
        ref_table
    );

alter table promo_applies_to
    add constraint pk_promo_applies_to
        primary key ( promo_id,
                      ref_table )
            using index pk_promo_applies_to enable;

