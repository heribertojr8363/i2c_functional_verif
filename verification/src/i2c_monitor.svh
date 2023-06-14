class i2c_monitor extends uvm_monitor;
    `uvm_component_utils(i2c_monitor)

    virtual i2c_interface vif;
    i2c_sequence_item tr;
    //i2c_agent_config cfg;

    uvm_analysis_port #(i2c_sequence_item) mon_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_ap = new ("mon_ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr  = i2c_sequence_item::type_id::create("tr", this);
        if(!uvm_config_db#(virtual i2c_interface)::get(this, "","vif", vif))
    begin
	    `uvm_fatal("NOVIF", "The virtual connection wasn't succesful!");
    end
    endfunction

    task main_phase(uvm_phase phase);
	forever begin
		//super.run_phase(phase);
		repeat(4) @(posedge vif.clk);           
		collect_start();
		//if(!vif.i2c_sda) @(negedge vif.i2c_sda);

		    fork
			    collect_addr();
			    collect_rw();
			    collect_addr_acknowledge();
		    join

		    //@(negedge vif.i2c_scl);

		    if(!vif.rw) begin
			repeat(3) @(negedge vif.i2c_scl);

		        collect_write_data();
		        //collect_data_acknowledge();
		    end
		    else begin
					@(negedge vif.i2c_scl);
                    //collect_read_data();
                    collect_data_acknowledge();

		    end

		    repeat(3) @(posedge vif.clk);

		    collect_stop();
		    //if(vif.i2c_sda) @(posedge vif.i2c_sda);
		    
            mon_ap.write(tr);
	end
    endtask

    virtual task collect_start();

            @(negedge vif.clk);
		    tr.start <= vif.i2c_sda;
            tr.scl_start <= vif.i2c_scl;
		$display("MONITOR: START STATE");

	endtask

	virtual task collect_addr();

            foreach (tr.addr[i]) begin
                @(posedge vif.i2c_scl);
			    tr.addr[i] <= vif.i2c_sda;
		    end
		$display("MONITOR: ADDR STATE");

	endtask

	virtual task collect_write_data();

            foreach (tr.w_data[i])begin
                @(posedge vif.i2c_scl);
			    tr.recovery_w_data[i] <= vif.i2c_sda;
		    end
		$display("MONITOR: WRITE DATA STATE");

	endtask

	/*virtual task collect_read_data();

		foreach (tr.r_data[i])begin
			@(negedge vif.i2c_scl);
			tr.r_data[7-i] <= vif.i2c_sda;
		end
		$display("MONITOR: READ DATA STATE");

	endtask*/

	virtual task collect_rw();

            repeat(8) @(posedge vif.i2c_scl);
		    tr.rw_logic <= vif.i2c_sda;
		$display("MONITOR: RW STATE");

	endtask

	virtual task collect_addr_acknowledge();

		repeat(9) @(posedge vif.i2c_scl);
		tr.ack_addr <= vif.i2c_sda;
		$display("MONITOR: ADDR_ACK STATE");

	endtask

	virtual task collect_data_acknowledge();

		repeat(10) @(posedge vif.i2c_scl);
		tr.ack_data <= vif.i2c_sda;
		$display("MONITOR: DATA_ACK STATE");

	endtask

	virtual task collect_stop();

		@(negedge vif.clk);
		tr.stop <= vif.i2c_sda;
		tr.scl_stop <= vif.i2c_scl;
		$display("MONITOR: STOP STATE");

	endtask

endclass
