-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463881372 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\limo_driver_settlement_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/limo_driver_settlement_pkg.sql:null:b9256954e859f5b490d9e1a7c00232224acfe39b:create

create or replace package limo_driver_settlement_pkg as
    procedure create_driver_settlement (
        p_driver_id     in varchar2,
        p_settlement_id out varchar2
    );

end limo_driver_settlement_pkg;
/

