typedef class i2c_scoreboard;
 
class i2c_sb_subscriber extends uvm_subscriber#(i2c_sequence_item);
   `uvm_component_utils(i2c_sb_subscriber)
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void write(i2c_sequence_item t);
      i2c_scoreboard i2c_sb;
 
      $cast( i2c_sb, m_parent );
      i2c_sb.check_i2c_start(t);
      i2c_sb.check_i2c_rw(t);
      i2c_sb.check_i2c_stop(t);
   endfunction: write
endclass: i2c_sb_subscriber
