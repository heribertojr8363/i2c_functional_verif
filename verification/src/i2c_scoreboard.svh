class i2c_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(i2c_scoreboard)
 
   uvm_analysis_export#(i2c_sequence_item) i2c_analysis_export;
   local i2c_sb_subscriber i2c_sb_sub;
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      i2c_analysis_export = new( .name("i2c_analysis_export"), .parent(this));
      i2c_sb_sub = i2c_sb_subscriber::type_id::create(.name("i2c_sb_sub"), .parent(this));
   endfunction: build_phase
 
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      i2c_analysis_export.connect(i2c_sb_sub.analysis_export);
   endfunction: connect_phase
 
   virtual function void check_i2c(i2c_sequence_item i2c_tx);
      uvm_table_printer p = new;
      int count = 0;
      if (i2c_tx.start == 0 && i2c_tx.scl_start == 1) begin
         `uvm_info("i2c_scoreboard",
                       { "Start condition passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
      end else begin
        `uvm_error("i2c_scoreboard",
                        { "Start condition failed.\n", i2c_tx.sprint(p) });
      end
      if (i2c_tx.rw_logic == 1) begin
        if(i2c_tx.ack_data == 1) begin
            `uvm_info("i2c_scoreboard",
                       { "Read operation passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
        end else begin
            `uvm_error("i2c_scoreboard",
                        { "Read operation failed.\n", i2c_tx.sprint(p) });
        end
      end else begin
        foreach(i2c_tx.w_data[i])begin
            if(i2c_tx.recovery_w_data[i] == i2c_tx.w_data[i]) count++;
        end
        if(count == 8) begin
            `uvm_info("i2c_scoreboard",
                       { "Write operation passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
        end else begin
            `uvm_error("i2c_scoreboard",
                        { "Write operation failed.\n", i2c_tx.sprint(p) });
        end
      end
      if (i2c_tx.stop == 1 && i2c_tx.scl_stop == 1) begin
         `uvm_info("i2c_scoreboard",
                       { "Stop condition passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
      end else begin
        `uvm_error("i2c_scoreboard",
                        { "Stop condition failed.\n", i2c_tx.sprint(p) });
      end

   endfunction: check_i2c



   /*virtual function void check_write_read_i2c(i2c_sequence_item i2c_tx);
      int count = 0;
      uvm_table_printer p = new;
      
   endfunction: check_write_read_i2c

   virtual function void check_stop_condition_i2c(i2c_sequence_item i2c_tx);
      uvm_table_printer p = new;
      if (i2c_tx.stop == 1 && i2c_tx.scl_stop == 1) begin
         `uvm_info("i2c_scoreboard",
                       { "Stop condition passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
      end else begin
        `uvm_error("i2c_scoreboard",
                        { "Stop condition failed.\n", i2c_tx.sprint(p) });
      end
   endfunction: check_stop_condition_i2c*/

endclass: i2c_scoreboard
