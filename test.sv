class test;
virtual ram_intf.drv drv_vif;
virtual ram_intf.mon mon_vif;
virtual ram_intf.refr ref_vif;
environment env;

function new(virtual ram_intf.drv drv_vif,
                 virtual ram_intf.mon mon_vif,
                 virtual ram_intf.refr ref_vif);
         this.drv_vif = drv_vif;
         this.mon_vif = mon_vif;
         this.ref_vif = ref_vif;
	$display("TEST started");
endfunction

task run();
 env=new(drv_vif,mon_vif,ref_vif);
 env.build;
 env.run;
endtask
endclass

class test_t1 extends test;
trans_read trans_t1;
function new(virtual ram_intf.drv drv_vif, virtual ram_intf.mon mon_vif, virtual ram_intf.refr ref_vif);
	super.new(drv_vif, mon_vif, ref_vif);
endfunction

task run();
 env=new(drv_vif,mon_vif,ref_vif);
 env.build;
begin
	trans_t1 = new();
	env.gen.trans = trans_t1;
end
 env.run;
endtask
endclass
class test_t2 extends test;
trans_write trans_t2;
function new(virtual ram_intf.drv drv_vif, virtual ram_intf.mon mon_vif, virtual ram_intf.refr ref_vif);
	super.new(drv_vif, mon_vif, ref_vif);
endfunction

task run();
 env=new(drv_vif,mon_vif,ref_vif);
 env.build;
begin
	trans_t2 = new();
	env.gen.trans = trans_t2;
end
 env.run;
endtask
endclass

class test_t3 extends test;
 trans_ill_rw trans_t3;
function new(virtual ram_intf.drv drv_vif, virtual ram_intf.mon mon_vif, virtual ram_intf.refr ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
endfunction

task run();
 env=new(drv_vif,mon_vif,ref_vif);
 env.build;
begin
        trans_t3 = new();
        env.gen.trans = trans_t3;
end
 env.run;
endtask
endclass

class test_t4 extends test;
 trans_read_write_chk trans_t4;
function new(virtual ram_intf.drv drv_vif, virtual ram_intf.mon mon_vif, virtual ram_intf.refr ref_vif);
        super.new(drv_vif, mon_vif, ref_vif);
endfunction

task run();
 env=new(drv_vif,mon_vif,ref_vif);
 env.build;
begin
        trans_t4 = new();
        env.gen.trans = trans_t4;
end
 env.run;
endtask
endclass

