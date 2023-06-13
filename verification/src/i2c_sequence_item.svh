class i2c_sequence_item  extends uvm_sequence_item; 

  /*rand bit start;
  rand bit stop;
  rand bit rw;*/
  rand logic [6:0] addr;
  rand logic [7:0] w_data;

  function new(string name = "i2c_sequence_item");
    super.new(name);
  endfunction

  `uvm_object_param_utils_begin(i2c_sequence_item)
    //`uvm_field_int(start, UVM_ALL_ON)
    //`uvm_field_int(stop, UVM_ALL_ON)
    //`uvm_field_int(rw, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(w_data, UVM_ALL_ON)
  `uvm_object_utils_end

   virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    // Print fields specific to this sequence item
    //printer.print_field("start", start, $bits(start), UVM_DEC);
    //printer.print_field("stop", stop, $bits(stop), UVM_DEC);
    //printer.print_field("rw", rw, $bits(rw), UVM_DEC);
    printer.print_field("addr", addr, $bits(addr), UVM_BIN);
    printer.print_field("w_data", w_data, $bits(w_data), UVM_BIN);
  endfunction

endclass
