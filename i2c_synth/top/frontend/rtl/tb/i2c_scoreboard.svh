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
 
   
   virtual function void check_i2c_start(i2c_sequence_item i2c_tx);
      
      uvm_table_printer p = new;
      int f_start = 0;
      f_start = $fopen("./start_condition.txt", "a");

      if (i2c_tx.start == 0 && i2c_tx.scl_start == 1) begin
         `uvm_info("i2c_scoreboard",
                       { "Start condition passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
         if (f_start) begin
            $fwrite(f_start, "i2c_scoreboard \n Start condition passed.\n");
            $fwrite(f_start, i2c_tx.sprint(p));
         end else begin
            `uvm_error("i2c_scoreboard", {"Failed to open file: start_condition.txt"});
         end
      end else begin
        `uvm_error("i2c_scoreboard",
                        { "Start condition failed.\n", i2c_tx.sprint(p) });
         if (f_start) begin
            $fwrite(f_start, "i2c_scoreboard \n Start condition failed.\n");
            $fwrite(f_start, i2c_tx.sprint(p));
         end else begin
            `uvm_error("i2c_scoreboard", {"Failed to open file: start_condition.txt"});
         end
      end

      close_file(f_start);

   endfunction: check_i2c_start



   virtual function void check_i2c_rw(i2c_sequence_item i2c_tx);
      int count = 0;
	   int f_rw = 0;
      uvm_table_printer p = new;
	   f_rw = $fopen("./rw_check.txt", "a");

      if (i2c_tx.rw_logic == 1) begin
        if(i2c_tx.ack_data == 1) begin
            `uvm_info("i2c_scoreboard",
                       { "Read operation passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
		      if (f_rw) begin
            	$fwrite(f_rw, "i2c_scoreboard \n Read operation passed.\n");
			      $fwrite(f_rw, i2c_tx.sprint(p));
         	end else begin
            		`uvm_error("i2c_scoreboard", {"Failed to open file: rw_check.txt"});
         	end
        end else begin
            `uvm_error("i2c_scoreboard",
                        { "Read operation failed.\n", i2c_tx.sprint(p) });
		      if (f_rw) begin
            	$fwrite(f_rw, "i2c_scoreboard \n Read operation failed.\n");
			      $fwrite(f_rw, i2c_tx.sprint(p));
         	end else begin
            		`uvm_error("i2c_scoreboard", {"Failed to open file: rw_check.txt"});
        	   end
         end 
      end else begin
        foreach(i2c_tx.w_data[i])begin
            if(i2c_tx.recovery_w_data[i] == i2c_tx.w_data[i]) count++;
        end
        if(count == 8) begin
            `uvm_info("i2c_scoreboard",
                       { "Write operation passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
            if (f_rw) begin
            	$fwrite(f_rw, "i2c_scoreboard \n Write operation passed.\n");
			      $fwrite(f_rw, i2c_tx.sprint(p));
         	end else begin
            		`uvm_error("i2c_scoreboard", {"Failed to open file: rw_check.txt"});
         	end
        end else begin
            `uvm_error("i2c_scoreboard",
                        { "Write operation failed.\n", i2c_tx.sprint(p) });
            if (f_rw) begin
            	$fwrite(f_rw, "i2c_scoreboard \n Write operation failed.\n");
			      $fwrite(f_rw, i2c_tx.sprint(p));
         	end else begin
            		`uvm_error("i2c_scoreboard", {"Failed to open file: rw_check.txt"});
         	end
        end
      end    

      close_file(f_rw);
      
   endfunction: check_i2c_rw

   virtual function void check_i2c_stop(i2c_sequence_item i2c_tx);
      uvm_table_printer p = new;
	   int f_stop = 0;
      f_stop = $fopen("./stop_condition.txt", "a");

      if (i2c_tx.stop == 1 && i2c_tx.scl_stop == 1) begin
         `uvm_info("i2c_scoreboard",
                       { "Stop condition passed.\n", i2c_tx.sprint(p) }, UVM_LOW);
         if (f_stop) begin
            $fwrite(f_stop, "i2c_scoreboard \n Stop condition passed.\n");
            $fwrite(f_stop, i2c_tx.sprint(p));
         end else begin
            `uvm_error("i2c_scoreboard", {"Failed to open file: stop_condition.txt"});
         end
      end else begin
        `uvm_error("i2c_scoreboard",
                        { "Stop condition failed.\n", i2c_tx.sprint(p) });
         if (f_stop) begin
            $fwrite(f_stop, "i2c_scoreboard \n Stop condition failed.\n");
            $fwrite(f_stop, i2c_tx.sprint(p));
         end else begin
            `uvm_error("i2c_scoreboard", {"Failed to open file: stop_condition.txt"});
         end
      end

      close_file(f_stop);

   endfunction: check_i2c_stop 


// Função para fechar o arquivo
   function void close_file(int f);
      if (f) begin
         $fclose(f);
         f = 0;
      end
   endfunction : close_file
   

endclass: i2c_scoreboard
