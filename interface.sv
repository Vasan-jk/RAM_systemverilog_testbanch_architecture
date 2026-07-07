`include "defines.svh"
interface ram_intf(input clk, reset);
logic write_enb, read_enb;
logic [`DATA_WIDTH-1:0] data_in;
logic [`ADDRESS_WIDTH-1:0] address;
logic [`DATA_WIDTH-1:0] data_out;

clocking drv_cb @(posedge clk);
	default input #1 output #0;
	input data_out;
	output write_enb, read_enb, data_in, address;
endclocking
 
clocking mon_cb @(posedge clk);
	default input #1 output #0;
	input data_out, write_enb, read_enb, data_in, address;
endclocking 

clocking ref_cb @(posedge clk);
	default input #1 output #0;
	input data_out, write_enb, read_enb, data_in, address;
endclocking 

modport mon(clocking mon_cb, input reset);
modport drv(clocking drv_cb, input reset);
modport refr(clocking ref_cb);

endinterface



