create or replace package blitz_util as

--- Get Reservation ID

---- for USERS

    function get_user_email (
        p_app_user in varchar2 default null,
        p_user_id  in varchar2 default null
    ) return varchar2;

    function get_user_id (
        p_app_user    in varchar2 default null,
        p_screen_name in varchar2 default null
    ) return varchar2;

---- COMMENTS PROCEDURES


----- Find Mentions

    function find_mentions (
        p_clob in clob
    ) return varchar2;

--- COMMENT STUFF & NOTIFY
end blitz_util;
/


-- sqlcl_snapshot {"hash":"68bc947b3408a6b6e0b0c24ac109253a4af0111c","type":"PACKAGE_SPEC","name":"BLITZ_UTIL","schemaName":"WKSP_ELWAGHA50","sxml":""}