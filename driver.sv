class driver;
  transaction trans;
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) drv2ref;
  virtual ram_intf.drv vif;

  covergroup drv_cg;
    read:      coverpoint trans.read_enb { bins read_enable[] = {0, 1}; }
    write:     coverpoint trans.write_enb { bins write_enable[] = {0, 1}; }
    datain:    coverpoint trans.data_in { bins input_data[] = {[0:255]}; }
    addr:      coverpoint trans.address { bins addre[] = {[0:31]}; }
    readwrite: cross read, write{
	ignore_bins ig = binsof(read) intersect{1} && binsof(write) intersect {1};
    }
  endgroup

  function new(mailbox #(transaction) gen2drv, mailbox #(transaction) drv2ref, virtual ram_intf.drv vif);
    this.gen2drv = gen2drv;
    this.drv2ref = drv2ref;
    this.vif     = vif;
    drv_cg       = new();
    $display("DRIVER started");
  endfunction

  task run();
    repeat(3) @(vif.drv_cb);
    
    for(int i = 0; i < `num_transactions; i++) begin
      trans = new();
      gen2drv.get(trans); 
      
      @(vif.drv_cb);
      
      if (vif.reset == 0) begin
        vif.drv_cb.write_enb <= 0;
        vif.drv_cb.read_enb  <= 0;
        vif.drv_cb.data_in   <= 0; 
        vif.drv_cb.address   <= 0;
        drv2ref.put(trans); 
      end 
      else begin
        vif.drv_cb.write_enb <= trans.write_enb;
        vif.drv_cb.read_enb  <= trans.read_enb;
        vif.drv_cb.data_in   <= trans.data_in;
        vif.drv_cb.address   <= trans.address;
        drv2ref.put(trans);
        
        $display("[%0t] DRV: Packet sent | Addr: %h, Data: %h, W_en: %b, R_en: %b", 
                 $time, trans.address, trans.data_in, trans.write_enb, trans.read_enb);
                 
        drv_cg.sample();
        $display("Input Functional Coverage: %0.2f%%", drv_cg.get_coverage());
      end
    end
  endtask
endclass
