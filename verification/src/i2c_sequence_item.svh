class i2c_sequence_item  extends uvm_sequence_item; 

  bit start;
  bit stop;
  rand logic [6:0] addr;
  rand logic [7:0] w_data;
  logic [7:0] recovery_w_data;
  logic [7:0] r_data;
  bit ack_addr;
  bit ack_data;
  rand bit rw_logic;
  bit scl_start;
  bit scl_stop;

  function new(string name = "i2c_sequence_item");
    super.new(name);
  endfunction

  `uvm_object_param_utils_begin(i2c_sequence_item)
    `uvm_field_int(start, UVM_ALL_ON)
    `uvm_field_int(stop, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(w_data, UVM_ALL_ON)
    `uvm_field_int(recovery_w_data, UVM_ALL_ON)
    `uvm_field_int(r_data, UVM_ALL_ON)
    `uvm_field_int(ack_addr, UVM_ALL_ON)
    `uvm_field_int(ack_data, UVM_ALL_ON)
    `uvm_field_int(rw_logic, UVM_ALL_ON)
  `uvm_object_utils_end

   virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    //Print fields specific to this sequence item
    printer.print_field("start", start, $bits(start), UVM_DEC);
    printer.print_field("stop", stop, $bits(stop), UVM_DEC);
    printer.print_field("addr", addr, $bits(addr), UVM_BIN);
    printer.print_field("w_data", w_data, $bits(w_data), UVM_BIN);
    printer.print_field("recovery_w_data", recovery_w_data, $bits(w_data), UVM_BIN);
    printer.print_field("r_data", r_data, $bits(r_data), UVM_BIN);
    printer.print_field("ack_addr", ack_addr, $bits(ack_addr), UVM_BIN);
    printer.print_field("ack_data", ack_data, $bits(ack_data), UVM_BIN);
    printer.print_field("rw_logic", rw_logic, $bits(rw_logic), UVM_BIN);
  endfunction

endclass
