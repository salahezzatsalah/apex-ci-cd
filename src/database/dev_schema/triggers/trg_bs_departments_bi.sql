create or replace editionable trigger trg_bs_departments_bi before
    insert on bs_departments
    for each row
begin
    if :new.id is null then
        select
            seq_bs_departments.nextval
        into :new.id
        from
            dual;

    end if;
end;
/

alter trigger trg_bs_departments_bi enable;


-- sqlcl_snapshot {"hash":"4495f2b1e249754bf38e62deab7c1ce1b25a8115","type":"TRIGGER","name":"TRG_BS_DEPARTMENTS_BI","schemaName":"DEV_SCHEMA","sxml":""}