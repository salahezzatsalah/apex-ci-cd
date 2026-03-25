-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464054554 stripComments:false  logicalFilePath:featureinitial-sync\dev_schema\triggers\biu_fast_track_assignments.sql
-- sqlcl_snapshot src/database/dev_schema/triggers/biu_fast_track_assignments.sql:null:5ec8d31611e947c526b727f9e69b26bed0cfa9e4:create

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

