create or replace editionable trigger lpa_bi_assignment_id before
    insert on limo_product_assignments
    for each row
begin
    if :new.assignment_id is null then
        :new.assignment_id := 'LPA-' || limo_assign_id_seq.nextval;
    end if;
end;
/

alter trigger lpa_bi_assignment_id enable;


-- sqlcl_snapshot {"hash":"6242d8968e136332efd0d3ba78f75052df9fd1a2","type":"TRIGGER","name":"LPA_BI_ASSIGNMENT_ID","schemaName":"WKSP_ELWAGHA50","sxml":""}