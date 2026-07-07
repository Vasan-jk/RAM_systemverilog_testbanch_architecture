`timescale 1ns/100ps
`include "defines.svh"

module top;

    import ram_package::*;

    logic clk;
    logic reset;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Reset generation
    initial begin
        reset = 0;
        repeat (1) @(posedge clk);
        reset = 1;	
        repeat (1) @(posedge clk);
	reset = 0;
        repeat (1) @(posedge clk);
	reset = 1;
    end

    // Interface instance
    ram_intf intrf(clk, reset);

    // DUT instance (interface connection)
    ram_dut DUV(.data_in(intrf.data_in),.data_out(intrf.data_out),.address(intrf.address), .write_enb(intrf.write_enb), .read_enb(intrf.read_enb), .reset(reset), .clk(clk));

    // Test object
    test tst;
    test_t1 tstt1;
    test_t2 tstt2;
    test_t3 tstt3;
    test_t4 tstt4;
    // Start test
    initial begin
        tst = new(intrf.drv, intrf.mon, intrf.refr);
        tstt1 = new(intrf.drv, intrf.mon, intrf.refr);
        tstt2 = new(intrf.drv, intrf.mon, intrf.refr);
        tstt3 = new(intrf.drv, intrf.mon, intrf.refr);
        tstt4 = new(intrf.drv, intrf.mon, intrf.refr);
        $display("-------------------------BASE TEST-------------------------");
	tst.run();
        $display("-------------------------TEST 1-------------------------");
	tstt1.run();
        $display("-------------------------TEST 2-------------------------");
	tstt2.run();
        $display("-------------------------TEST 3-------------------------");
	tstt3.run();
        $display("-------------------------TEST 4-------------------------");
	tstt4.run();
	$finish();
    end

endmodule
