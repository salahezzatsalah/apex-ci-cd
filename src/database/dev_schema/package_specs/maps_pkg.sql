create or replace package maps_pkg as
    procedure compute_route_by_place_id (
        p_from_place_id in varchar2,
        p_to_place_id   in varchar2,
        o_distance_km   out number,
        o_duration_min  out number,
        o_raw_json      out clob
    );

end maps_pkg;
/


-- sqlcl_snapshot {"hash":"6391eec05cf21aeea63e8ae3183a142cbe569e8d","type":"PACKAGE_SPEC","name":"MAPS_PKG","schemaName":"DEV_SCHEMA","sxml":""}