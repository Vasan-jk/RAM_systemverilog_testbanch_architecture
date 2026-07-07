class monitor; 
transaction trans; 
mailbox #(transaction) mon2scb; 
virtual ram_intf.mon vif; 
covergroup mon_cg; 
dataout: coverpoint trans.data_out { 
	bins output_data = {[0:255]}; 
}
endgroup 
function new(mailbox #(transaction) mon2scb, virtual ram_intf.mon vif); 
	this.mon2scb = mon2scb; 
	this.vif = vif; 
	mon_cg = new(); 
	$display("MONITOR started"); 
endfunction 

task run(); 
	repeat(3) @(vif.mon_cb); 
	for(int i = 0; i < `num_transactions; i++) begin 
		@(vif.mon_cb); // sample on clock edge 
		trans = new(); 
		#1;
		trans.data_out = vif.mon_cb.data_out; 
		mon2scb.put(trans); mon_cg.sample(); 
	//	$display("[%0t]MON: data_out = %p",$time, vif); 
	end 
	$display("MON: Output coverage = %0.2f", 	
	mon_cg.get_coverage()); 
	@(vif.mon_cb);
endtask
endclass
