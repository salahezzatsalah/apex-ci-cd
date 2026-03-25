create or replace editionable trigger trg_lpa_single_current_driver for
    insert or update on limo_product_assignments
compound trigger

  -- Declare a collection to store affected rows
    type t_assignment_info is record (
            product_id     limo_product_assignments.product_id%type,
            reservation_id limo_product_assignments.reservation_id%type,
            assignment_id  limo_product_assignments.assignment_id%type,
            driver_status  limo_product_assignments.driver_status%type
    );
    type t_assignment_table is
        table of t_assignment_info index by pls_integer;
    g_assignments t_assignment_table;
    g_index       integer := 0;
    after each row is begin
        if :new.driver_status = 'CURRENT' then
            g_index := g_index + 1;
            g_assignments(g_index).product_id := :new.product_id;
            g_assignments(g_index).reservation_id := :new.reservation_id;
            g_assignments(g_index).assignment_id := :new.assignment_id;
            g_assignments(g_index).driver_status := :new.driver_status;
        end if;
    end after each row;
    after statement is begin
        for i in 1..g_index loop
            update limo_product_assignments
            set
                driver_status = 'PREVIOUS'
            where
                    product_id = g_assignments(i).product_id
                and reservation_id = g_assignments(i).reservation_id
                and driver_status = 'CURRENT'
                and assignment_id <> g_assignments(i).assignment_id;

        end loop;
    end after statement;
end trg_lpa_single_current_driver;
/

alter trigger trg_lpa_single_current_driver enable;


-- sqlcl_snapshot {"hash":"871207088831f04385112ddbb2ee903ade409bff","type":"TRIGGER","name":"TRG_LPA_SINGLE_CURRENT_DRIVER","schemaName":"WKSP_ELWAGHA50","sxml":""}