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


-- sqlcl_snapshot {"hash":"c87ce52d17019d6fcb27ce0266dc1d07e1c69062","type":"PACKAGE_SPEC","name":"CAR_CATALOG_ROUTER_PKG","schemaName":"WKSP_ELWAGHA50","sxml":""}