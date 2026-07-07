`include "defines.svh"
class transaction;
rand bit write_enb, read_enb;
rand bit [`DATA_WIDTH-1:0] data_in;
rand bit [`ADDRESS_WIDTH-1:0] address;
bit [`DATA_WIDTH-1:0] data_out;

//constraint wr_enb_and_rd_enb {
//	{write_enb, read_enb} != 2'b11;
//}
virtual function transaction copy();
 copy = new();
 copy.data_in=this.data_in;
 copy.write_enb=this.write_enb;
 copy.read_enb=this.read_enb;
 copy.address=this.address;
 return copy;
endfunction
endclass


class trans_ill_rw extends transaction;
constraint awr{ {write_enb,read_enb} == 2'b11;}
virtual function transaction copy();
 copy = new();
 copy.data_in=this.data_in;
 copy.write_enb=this.write_enb;
 copy.read_enb=this.read_enb;
 copy.address=this.address;
 return copy;
endfunction
endclass

class trans_write extends transaction;
constraint wr{ {write_enb,read_enb} == 2'b10;}
virtual function transaction copy();
 copy = new();
 copy.data_in=this.data_in;
 copy.write_enb=this.write_enb;
 copy.read_enb=this.read_enb;
 copy.address=this.address;
 return copy;
endfunction
endclass

class trans_read extends transaction;
constraint rd{ {write_enb,read_enb} == 2'b01;}
virtual function transaction copy();
 copy = new();
 copy.data_in=this.data_in;
 copy.write_enb=this.write_enb;
 copy.read_enb=this.read_enb;
 copy.address=this.address;
 return copy;
endfunction
endclass


class trans_read_write_chk extends transaction;
bit [4:0]q[$];
constraint c {
        (!read_enb && write_enb) || (read_enb && !write_enb); 
    }

    function void post_randomize();
        if (write_enb)
            q.push_front(address);

        if (read_enb && q.size() > 0)
            address = q.pop_back();
    endfunction
virtual function transaction copy();
 copy = new();
 copy.data_in=this.data_in;
 copy.write_enb=this.write_enb;
 copy.read_enb=this.read_enb;
 copy.address=this.address;
 return copy;
endfunction
endclass




