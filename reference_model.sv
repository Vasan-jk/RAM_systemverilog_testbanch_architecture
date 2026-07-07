class reference_model;

    mailbox #(transaction) drv2ref;
    mailbox #(transaction) ref2scb;
    virtual ram_intf.refr vif;

    // 32-depth memory
    reg [`DATA_WIDTH-1:0] mem [0:31];

    integer i;

    function new(mailbox #(transaction) drv2ref,
                 mailbox #(transaction) ref2scb,
                 virtual ram_intf.refr vif);

        this.drv2ref = drv2ref;
        this.ref2scb = ref2scb;
        this.vif = vif;

        for (i = 0; i < 32; i++)
            mem[i] = 0;

    endfunction

    task run();

        for (int i = 0; i < `num_transactions; i++) begin
    	transaction trans;

            drv2ref.get(trans);

            @(vif.ref_cb);

            begin

                if (trans.write_enb && !trans.read_enb) begin
			mem[trans.address] = trans.data_in;
                end

                if (trans.read_enb && !trans.write_enb) begin
                    trans.data_out = mem[trans.address];
                end
		if(!trans.read_enb && !trans.write_enb) begin
		    trans.data_out = trans.data_out;
		end
            end

            ref2scb.put(trans);

        end

    endtask

endclass
