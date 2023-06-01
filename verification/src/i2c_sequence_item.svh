class i2c_sequence_item #(ADDR_WIDTH=7,DATA_WIDTH=8) extends uvm_sequence_item; 

  rand bit [ADDR_WIDTH-1:0] addr;
  rand bit [DATA_WIDTH-1:0] data;
  rand bit read;

  function new(string name = "");
    super.new(name);
  endfunction

  `uvm_object_param_utils_begin(i2c_sequence_item)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(read, UVM_ALL_ON)
  `uvm_object_utils_end
endclass
