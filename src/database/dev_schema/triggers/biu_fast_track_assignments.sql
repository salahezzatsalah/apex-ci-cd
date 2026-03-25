create or replace editionable trigger biu_fast_track_assignments before
    insert on fast_track_assignments
    for each row
begin
    if :new.assignment_id is null then
        select
            'FTA-'
            || lpad(
                to_char(fast_track_assign_seq.nextval),
                3,
                '0'
            )
        into :new.assignment_id
        from
            dual;

    end if;

    if :new.created is null then
        :new.created := current_timestamp;
    end if;

end;
/

alter trigger biu_fast_track_assignments enable;


-- sqlcl_snapshot {"hash":"d0ed0318d191bc67a27f395bf1b06410149edcf9","type":"TRIGGER","name":"BIU_FAST_TRACK_ASSIGNMENTS","schemaName":"DEV_SCHEMA","sxml":""}