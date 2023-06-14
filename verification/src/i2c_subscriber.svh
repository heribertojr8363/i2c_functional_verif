class i2c_subscriber extends uvm_subscriber#(i2c_sequence_item);
   `uvm_component_utils(i2c_subscriber)
 
   i2c_sequence_item tr;
 
   covergroup i2c_cg;
      start_cp:         coverpoint tr.start {bins str_null = {0};}
      scl_start_cp:     coverpoint tr.scl_start {bins str_scl_true = {1};}
      addr_cp:          coverpoint tr.addr;
      rw_logic_cp:      coverpoint tr.rw_logic;
      recovery_data_cp: coverpoint tr.recovery_w_data;
      ack_data_cp:      coverpoint tr.ack_data {bins ack_true = {1};}
      stop_cp:          coverpoint tr.stop {bins stp_true = {1};}
      scl_stop_cp:      coverpoint tr.scl_start {bins stp_scl_true = {1};}
      cross start_cp, scl_start_cp, addr_cp, rw_logic_cp, recovery_data_cp, ack_data_cp, stop_cp, scl_start_cp;
   endgroup: i2c_cg
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
      i2c_cg = new;
   endfunction: new
 
   function void write(i2c_sequence_item t);
      tr = t;
      i2c_cg.sample();
   endfunction: write
endclass: i2c_subscriber
