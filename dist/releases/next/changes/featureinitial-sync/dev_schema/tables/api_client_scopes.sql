-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463926939 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\tables\api_client_scopes.sql
-- sqlcl_snapshot src/database/dev_schema/tables/api_client_scopes.sql:null:7055c67d74e8de3ea0f8874945df1d85d4a7659b:create

create table api_client_scopes (
    id        number,
    client_id varchar2(100 byte),
    scope     varchar2(100 byte)
);

alter table api_client_scopes add primary key ( id )
    using index enable;

