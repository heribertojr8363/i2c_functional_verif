class i2c_sequencer extends uvm_sequencer #(i2c_sequence_item);
    `uvm_component_utils(i2c_sequencer)

    //calling and allocating the sequencer 
    function new (string name = "i2c_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass: i2c_sequencer