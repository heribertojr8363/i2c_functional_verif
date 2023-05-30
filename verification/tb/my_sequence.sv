class my_sequence extends uvm_sequence #(i2c_vip_sequence_item);
    `uvm_object_utils(my_sequence)

    function new(string name="my_sequence");
        super.new(name);
    endfunction: new

    task body;
        i2c_vip_sequence_item #(.ADDR_WIDTH(7), .DATA_WIDTH(8)) tr;
        forever begin
            tr = i2c_vip_sequence_item #(.ADDR_WIDTH(7), .DATA_WIDTH(8))::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);
        end
    endtask: body
endclass: my_sequence
