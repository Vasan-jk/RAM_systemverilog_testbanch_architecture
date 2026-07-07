class scoreboard;
  transaction reftrans, montrans;
  mailbox #(transaction) mon2scb;
  mailbox #(transaction) ref2scb;
  int fail_count;

  logic [`DATA_WIDTH-1:0] ref_mem [`DATA_DEPTH-1:0];
  logic [`DATA_WIDTH-1:0] mon_mem [`DATA_DEPTH-1:0];

  logic [`DATA_DEPTH-1:0] last_read_addr;
  bit was_read_op = 0;

  function new(mailbox #(transaction) mon2scb, mailbox #(transaction) ref2scb);
    this.mon2scb = mon2scb;
    this.ref2scb = ref2scb;
    for (int i = 0; i < `DATA_DEPTH; i++) begin
      ref_mem[i] = 0;
      mon_mem[i] = 0;
    end
    $display("SCOREBOARD started");
  endfunction

  task run();

    for(int i = 0; i < `num_transactions; i++) begin
      reftrans = new();
      montrans = new();

      fork
        begin
          mon2scb.get(montrans);
          $display("[%0t][SCB]GOT monitor packet",$time);
 end
        begin
          ref2scb.get(reftrans);
          $display("[%0t][SCB]GOT reference model packet",$time);
        end
      join

      if (reftrans.write_enb) begin
        ref_mem[reftrans.address] = reftrans.data_in;
      end

      if (was_read_op) begin
        mon_mem[last_read_addr] = montrans.data_out;
        report();
      end

      if (reftrans.read_enb) begin
        last_read_addr = reftrans.address;
        was_read_op = 1;
      end else begin
        was_read_op = 0;
      end
    end
  endtask

  task report();
    if (mon_mem[last_read_addr] === ref_mem[last_read_addr]) begin
      $display("[%0t]PASS: mon_data_out:%0h, ref_data_out: %0h at Addr: %h",
               $time,mon_mem[last_read_addr], ref_mem[last_read_addr], last_read_addr);
    end
    else begin
 $display("[%0t]FAIL: ref_data_out: %0h, mon_data_out: %0h at Addr: %h",
               $time,ref_mem[last_read_addr], mon_mem[last_read_addr], last_read_addr);
      fail_count++;
      $display("FAIL COUNT: %0d", fail_count);
    end
  endtask
endclass
