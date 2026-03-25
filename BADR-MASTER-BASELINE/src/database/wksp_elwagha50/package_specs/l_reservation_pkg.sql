create or replace package l_reservation_pkg as
    type t_result is record (
            sub_res_id     varchar2(30),
            main_res_id    varchar2(30),
            status_message varchar2(4000)
    );
    procedure create_limo_res (
        p_main_res_id     in out varchar2,
        p_sub_res_id      in out varchar2,
        p_customer_id     in varchar2,
        p_trip_type       in varchar2,
        p_from_location   in varchar2,
        p_to_location     in varchar2,
        p_from_place_id   in varchar2,
        p_to_place_id     in varchar2,
        p_currency        in varchar2,
        p_exchange_rate   in number,
        p_ticket_number   in varchar2,
        p_signage_details in varchar2,
        p_notes           in varchar2,
        p_status          in varchar2,
        p_cat_item_id     in varchar2,
        p_res_date_from   in date,
        p_res_date_to     in date,
        p_res_time        in varchar2,
        p_service_class   in varchar2,
        p_trip_price      in number,
        p_ticket_url      in varchar2,
        p_source          in sublevel_limo_res.source%type,
        p_passengers_no   in sublevel_limo_res.passengers_no%type default null,
        p_luggage_no      in sublevel_limo_res.luggage_no%type default null,
        p_request_type    in sublevel_limo_res.request_type%type default null,
        o_result          out t_result
    );

    procedure update_limo_res (
        p_sub_res_id      in varchar2,
        p_cat_item_id     in varchar2,
        p_trip_type       in varchar2,
        p_res_date_from   in date,
        p_res_date_to     in date,
        p_res_time        in varchar2,
        p_from_location   in varchar2,
        p_to_location     in varchar2,
        p_from_place_id   in varchar2,
        p_to_place_id     in varchar2,
        p_service_class   in varchar2,
        p_trip_price      in number,
        p_ticket_number   in varchar2,
        p_signage_details in varchar2,
        p_notes           in varchar2,
        p_status          in varchar2,
        p_ticket_url      in varchar2,
        p_source          in sublevel_limo_res.source%type,
        p_passengers_no   in sublevel_limo_res.passengers_no%type default null,
        p_luggage_no      in sublevel_limo_res.luggage_no%type default null,
        p_request_type    in sublevel_limo_res.request_type%type default null,
        o_result          out t_result
    );

    procedure delete_limo_res (
        p_sub_res_id in varchar2,
        o_result     out t_result
    );

    procedure create_return_res (
        p_parent_sub_res_id in varchar2,
        p_res_date          in date,
        p_res_time          in varchar2,
        p_trip_price        in number,
        p_return_status     in varchar2 default 'CONFIRMED',
        o_sub_res_id        out varchar2
    );

end l_reservation_pkg;
/


-- sqlcl_snapshot {"hash":"7201a3c94f2fe6f5c49243a87c2f1ec7993c4aae","type":"PACKAGE_SPEC","name":"L_RESERVATION_PKG","schemaName":"WKSP_ELWAGHA50","sxml":""}