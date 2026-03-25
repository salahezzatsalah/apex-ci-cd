create or replace package body reservation_log as

    procedure log_interaction (
        p_reservation_id in varchar2,
        p_type           in varchar2
    ) is

        l_action varchar2(50);
        l_page   number := to_number ( v('APP_PAGE_ID') );
        l_user   varchar2(50) := apex_util.get_session_state('APP_USER_ID');
    begin
        -- Determine action by page number
        case l_page
            when 173 then
                l_action := 'View Hotel Reservation';
            when 174 then
                l_action := 'Edit Hotel Reservation';
            when 221 then
                l_action := 'Edit Apartment Reservation';
            when 341 then
                l_action := 'Limo Booking';
            when 351 then
                l_action := 'Airport Service Edit';
            else
                l_action := 'Unknown';
        end case;

        -- Insert interaction record
        insert into reservation_interactions_log (
            reservation_id,
            reservation_type,
            user_id,
            app_page,
            action
        ) values ( p_reservation_id,
                   upper(p_type),
                   l_user,
                   l_page,
                   l_action );

    end log_interaction;

    function log_and_summarize (
        p_reservation_id in varchar2,
        p_type           in varchar2
    ) return varchar2 is
        l_result varchar2(500);
    begin
        -- Log this interaction
        log_interaction(p_reservation_id, p_type);

        -- Return a summary
        select
            count(*)
            || ' interaction'
            ||
            case
                when count(*) > 1 then
                        's'
            end
            || ' by '
            || count(distinct user_id)
            || ' user'
            ||
            case
                when count(distinct user_id) > 1 then
                        's'
            end
        into l_result
        from
            reservation_interactions_log
        where
                reservation_id = p_reservation_id
            and reservation_type = upper(p_type);

        return l_result;
    end log_and_summarize;

end reservation_log;
/


-- sqlcl_snapshot {"hash":"bd2f79267caf8a2f71ab9fab74251ac8e6de9e04","type":"PACKAGE_BODY","name":"RESERVATION_LOG","schemaName":"WKSP_ELWAGHA50","sxml":""}