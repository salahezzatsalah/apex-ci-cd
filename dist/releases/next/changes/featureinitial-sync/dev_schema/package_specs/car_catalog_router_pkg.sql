-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463875609 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\car_catalog_router_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/car_catalog_router_pkg.sql:null:c87ce52d17019d6fcb27ce0266dc1d07e1c69062:create

create or replace package car_catalog_router_pkg as

  /* ===============================
     EDIT (Dialog)
  ================================ */
    function edit_url (
        p_car_type_id in varchar2
    ) return varchar2;

  /* ===============================
     PRICES
  ================================ */
    function prices_url (
        p_car_type_id in varchar2
    ) return varchar2;

  /* ===============================
     GALLERY
  ================================ */
    function gallery_url (
        p_car_type_id in varchar2
    ) return varchar2;

  /* ===============================
     VIEW (Optional future)
  ================================ */
    function view_url (
        p_car_type_id in varchar2
    ) return varchar2;

end car_catalog_router_pkg;
/

