class environment;
virtual ram_intf.drv drv_vif;
virtual ram_intf.mon mon_vif;
virtual ram_intf.refr ref_vif;
mailbox #(transaction) gen2drv;
mailbox #(transaction) drv2ref;
mailbox #(transaction) mon2scb;
mailbox #(transaction) ref2scb;

generator gen;
driver drv;
monitor mon;
reference_model refr;
scoreboard scb;

function new( virtual ram_intf.drv drv_vif, virtual ram_intf.mon mon_vif, virtual ram_intf.refr ref_vif);
this.drv_vif = drv_vif;
this.mon_vif = mon_vif;
this.ref_vif = ref_vif;
$display("ENVIRONMENT started");
endfunction

task build();
begin
	gen2drv = new();
	drv2ref = new();
	mon2scb = new();
	ref2scb = new();
	
	gen = new(gen2drv);
	drv = new(gen2drv, drv2ref, drv_vif);
	mon = new(mon2scb, mon_vif);
	refr = new(drv2ref, ref2scb, ref_vif);
	scb = new(mon2scb, ref2scb);
end
endtask;

task run();
fork
	gen.run();
	drv.run();
	mon.run();
	refr.run();
	scb.run();
join
endtask

endclass
	
