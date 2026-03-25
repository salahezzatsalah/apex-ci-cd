-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774463851472 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\package_bodies\blitz_util.sql
-- sqlcl_snapshot src/database/dev_schema/package_bodies/blitz_util.sql:null:f47e7458d7f6e051f7687205a2abf3d505539e3e:create

create or replace package body blitz_util as

    function get_user_email (
        p_app_user in varchar2 default null,
        p_user_id  in varchar2 default null
    ) return varchar2 is
        l_email varchar2(255);
    begin
        select
            email
        into l_email
        from
            bs_employees
        where
            ( lower(username) = lower(p_app_user)
              or lower(email) = lower(p_app_user)
              or id = p_user_id )
            and status = 'Active'
            and account_locked_yn = 'N'
        fetch first 1 rows only;

        return l_email;
    exception
        when no_data_found then
            return null;
        when others then
            return null;
    end get_user_email;

-------- USER GET FUNCTIONS for USER_ID

    function get_user_id (
        p_app_user    in varchar2 default null,
        p_screen_name in varchar2 default null
    ) return varchar2 is
        l_id varchar2(300);
    begin
        select
            id
        into l_id
        from
            bs_employees
        where
            ( lower(username) = lower(p_app_user)
              or lower(email) = lower(p_app_user)
              or lower(screen_name) = lower(p_screen_name) )
            and status = 'Active'
            and account_locked_yn = 'N'
        fetch first 1 rows only;

        return l_id;
    exception
        when no_data_found then
            return null;
        when others then
            return null;
    end get_user_id;

------ FIND USERS MENTIONS

    function find_mentions (
        p_clob in clob
    ) return varchar2 is

        l_clob               clob;
        l_mention_list       varchar2(4000) := null;
        l_pos                integer := 1;
        l_match              varchar2(320);
        l_clob_length        integer;
        l_screen_name_exists boolean := false;
        l_loop_count         integer := 0;
        l_max_loops          integer := 100;
    begin
    -- Normalize characters
        l_clob := replace(p_clob, '+', ' ');
        l_clob := replace(l_clob, '.', ' ');
        l_clob := replace(l_clob, ',', ' ');
        l_clob := replace(l_clob, '@', ' @');  -- Ensure @ mentions are spaced

        l_clob_length := dbms_lob.getlength(l_clob);
        while l_pos <= l_clob_length loop
            if l_loop_count > l_max_loops then
                exit;
            end if;
            l_match := regexp_substr(l_clob, '@\S+', l_pos, 1);
            exit when l_match is null;
            l_match := lower(trim(l_match));
            l_match := ltrim(l_match, '@');
            l_match := rtrim(l_match, '.,;:"''\/-|!#$%^&*()[]');

        -- Check if the screen name exists in BS_EMPLOYEES
            l_screen_name_exists := false;
            for c1 in (
                select
                    id
                from
                    bs_employees
                where
                    lower(screen_name) = l_match
            ) loop
                l_screen_name_exists := true;
                exit;
            end loop;

            if
                l_screen_name_exists
                and instr(':'
                          || l_mention_list
                          || ':', ':'
                                  || l_match
                                  || ':') = 0
            then
                if l_mention_list is not null then
                    l_mention_list := l_mention_list
                                      || ':'
                                      || l_match;
                else
                    l_mention_list := l_match;
                end if;
            end if;

            l_pos := instr(l_clob, l_match, l_pos) + length(l_match);
            l_loop_count := l_loop_count + 1;
        end loop;

        return l_mention_list;
    end find_mentions;

------ Comments Notications



--------- reservations tag
end blitz_util;
/

