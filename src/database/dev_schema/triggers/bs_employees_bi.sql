create or replace editionable trigger bs_employees_bi before
    insert on bs_employees
    for each row
begin
    if :new.id is null then
        :new.id := 'EMP-'
                   || lpad(bs_employees_seq.nextval, 5, '0');

    end if;
end;
/

alter trigger bs_employees_bi enable;


-- sqlcl_snapshot {"hash":"aac404383611be8cdc643056b3f9ac77688cc29b","type":"TRIGGER","name":"BS_EMPLOYEES_BI","schemaName":"DEV_SCHEMA","sxml":""}