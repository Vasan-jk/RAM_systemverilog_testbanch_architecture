class generator;

transaction trans;

mailbox #(transaction)gen2drv;

function new(mailbox #(transaction)gen2drv);
	this.gen2drv = gen2drv;
	$display("GENERATOR started");
	trans = new();
endfunction

task run();
	for(int i = 0; i < `num_transactions;i++) begin
		assert(trans.randomize());
		gen2drv.put(trans.copy());
		$display("GEN: data_in: %0h, write_enb: %0b, read_enb:%0b, address: %0h",trans.data_in, trans.write_enb, trans.read_enb, trans.address);
end

endtask
endclass
