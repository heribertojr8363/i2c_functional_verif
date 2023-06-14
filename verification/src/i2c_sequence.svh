/*class write_op extends i2c_sequence_item;
  
endclass*/

class i2c_sequence extends uvm_sequence #(i2c_sequence_item);    
  `uvm_object_utils(i2c_sequence)

   i2c_sequence_item tr;

  function new(string name="i2c_sequence");
    super.new(name);
  endfunction: new

  task body;
    repeat(200) begin
      tr = i2c_sequence_item::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      finish_item(tr);
    end
  endtask: body
endclass: i2c_sequence
