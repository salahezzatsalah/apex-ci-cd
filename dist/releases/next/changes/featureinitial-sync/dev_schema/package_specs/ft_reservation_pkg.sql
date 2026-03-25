-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463879198 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_specs\ft_reservation_pkg.sql
-- sqlcl_snapshot src/database/dev_schema/package_specs/ft_reservation_pkg.sql:null:80937c839558d2c9321474fb1b6b09b17c3f8a10:create

create or replace package ft_reservation_pkg as
    type t_result is record (
            sub_res_id     varchar2(30),
            main_res_id    varchar2(30),
            status_message varchar2(4000)
    );
    procedure create_fast_track_res (
        p_main_res_id      in out varchar2,
        p_customer_id      in varchar2,
        p_cat_item_id      in varchar2,   -- was p_service_type
        p_res_date         in date,       -- was p_service_date
        p_res_time         in varchar2,
        p_airport_id       in varchar2,   -- was p_airport_name
        p_terminal_no      in varchar2,
        p_ticket_url       in varchar2,
        p_passengers_no    in number,
        p_passengers_info  in clob,       -- stored as JSON in table
        p_currency         in varchar2,
        p_exchange_rate    in number,
        p_service_class    in varchar2,   -- was p_class_type
        p_price_per_person in number,
        p_signage_details  in varchar2,
        p_notes            in varchar2,
        p_status           in varchar2 default 'PENDING',
        o_result           out t_result
    );

    procedure update_fast_track_res (
        p_sub_res_id       in varchar2,
        p_cat_item_id      in varchar2,
        p_service_class    in varchar2,
        p_res_date         in date,
        p_res_time         in varchar2,
        p_airport_id       in varchar2,
        p_terminal_no      in varchar2,
        p_passengers_no    in number,
        p_passengers_info  in clob,
        p_price_per_person in number,
        p_signage_details  in varchar2,
        p_notes            in varchar2,
        p_status           in varchar2,
        o_result           out t_result
    );

    procedure delete_fast_track_res (
        p_sub_res_id in varchar2,
        o_result     out t_result
    );

end ft_reservation_pkg;
/

