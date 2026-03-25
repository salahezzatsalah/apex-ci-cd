create or replace editionable trigger trg_lpa_from_product for
    update of trip_price, exchange_rate on sublevel_limo_res
compound trigger

  /* ===============================
     Collect affected sub reservations
     =============================== */
    type t_prod_set is
        table of pls_integer index by varchar2(30);
    g_prod_ids t_prod_set;

    procedure mark_prod (
        p_id varchar2
    ) is
    begin
        if p_id is not null then
            g_prod_ids(p_id) := 1;
        end if;
    end;

  /* ===============================
     Row-level: collect SUB_RES_ID
     =============================== */
    before each row is begin
        mark_prod(:new.sub_res_id);
    end before each row;

  /* ===============================
     Statement-level: recalc assignments
     =============================== */
    after statement is
        k varchar2(30);
    begin
        k := g_prod_ids.first;
        while k is not null loop

      -- 🔁 Recalculate all assignments linked to this sub-reservation
            for a in (
                select
                    assignment_id
                from
                    limo_product_assignments
                where
                    product_id = k
            ) loop
                begin
                    recalc_assignment_accounting(a.assignment_id);
                exception
                    when others then
                        dbms_output.put_line('LPA recalc (SUB_RES) failed for '
                                             || a.assignment_id
                                             || ': ' || sqlerrm);
                end;
            end loop;

            k := g_prod_ids.next(k);
        end loop;

    end after statement;
end trg_lpa_from_product;
/

alter trigger trg_lpa_from_product enable;


-- sqlcl_snapshot {"hash":"bb72bbea419d8d0ae5c5e3c7e10692266ff58cbc","type":"TRIGGER","name":"TRG_LPA_FROM_PRODUCT","schemaName":"WKSP_ELWAGHA50","sxml":""}