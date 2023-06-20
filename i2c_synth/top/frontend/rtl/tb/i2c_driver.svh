/*
 * Parameters:
 *
 *  ADDR_WIDTH: Sets I2C protocol address size, either 7 or 10 bits; This
 *  version supports only 7 (DEFAULT=7)
 *
 *  DATA_WIDTH: Sets word data word size to be driven by byte. Should be byte
 *  multiples, i.e. 8/16/24/32/... ; This version supports only 8 (DEFAULT=8)
 *
 *  cfg.initial_delay_clock: Sets the number of interface clock periods before
 *  driving a transaction (DEFAULT=0)
 *
 *  cfg.start_condition_post_delay: Sets the number of interface clock periods before
 *  driving a transaction (DEFAULT=0)
 *
 *  cfg.clk_divider: Sets SCL clock period based on interface clock (DEFAULT=2)
 *
 */
class i2c_driver extends uvm_driver #(i2c_sequence_item);
	`uvm_component_utils(i2c_driver)

	virtual i2c_interface vif;
	//i2c_agent_config cfg;
	i2c_sequence_item tr;
	//bit stop_scl;

	function new(string name = "i2c_driver", uvm_component parent = null);
			super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(virtual i2c_interface)::get(this, "", "vif", vif)) begin
			`uvm_fatal("NOVIF", "failed to get virtual interface")
			end
	endfunction : build_phase

	task reset_phase(uvm_phase phase);
    	phase.raise_objection(this);
    	@(posedge vif.reset);

    	//Reset write data channel   
    	vif.start  <= '0;  
    	vif.stop   <= '0;
    	vif.rw   <= '1;
		vif.addr <= '0;
		vif.w_data <= '0; 

    	//tr = null;
    	@(negedge vif.reset);
    	phase.drop_objection(this);
  	endtask : reset_phase

	task main_phase (uvm_phase phase);
		forever begin
			//repeat (cfg.initial_delay_clock) @(posedge vif.clk);
			seq_item_port.get_next_item(tr);
			//repeat(4) @(posedge vif.clk);
			drive_start();
			if(!vif.i2c_sda) @(negedge vif.i2c_sda);

			fork
				drive_addr();
				drive_rw();
				drive_addr_acknowledge();
			join

			//@(negedge vif.i2c_scl);

			if(!vif.rw) begin
				@(negedge vif.i2c_scl);

				drive_write_data();
				drive_data_acknowledge();

				//@(negedge vif.i2c_scl);
			end
			else begin
				repeat(2) @(negedge vif.i2c_scl);
				drive_read_data();
				repeat(2) @(negedge vif.i2c_scl);
			end
			
			//repeat(3) @(posedge vif.clk);

			drive_stop();
			//if(vif.i2c_sda) @(posedge vif.i2c_sda);

			seq_item_port.item_done();
		end
  endtask

	virtual task drive_start();
		@(posedge vif.clk);
		vif.start <= 1;
		vif.rw <= 1;
		//$display("DRIVER: START STATE");
	endtask

	virtual task drive_addr();
		foreach (tr.addr[i]) begin
			vif.addr[6-i] <= tr.addr[6-i];
		end
		//$display("DRIVER: ADDR STATE");
	endtask

	virtual task drive_write_data();
		foreach (tr.w_data[i])begin
			vif.w_data[7-i] <= tr.w_data[7-i];
		end
		//$display("DRIVER: DATA STATE");
	endtask

	virtual task drive_read_data();
		for (int i = 0; i<8; i++) begin
			@(negedge vif.i2c_scl);
			vif.i2c_sda <= tr.r_data[7-i];
		end
	endtask

	virtual task drive_rw();
		repeat(8) @(negedge vif.i2c_scl);
		vif.rw <= tr.rw_logic;
		//$display("DRIVER: RW STATE");
	endtask

	virtual task drive_addr_acknowledge();
		repeat(9) @(negedge vif.i2c_scl);
		vif.i2c_sda <= 1;
		//$display("DRIVER: ADDR_ACK STATE");
	endtask

	virtual task drive_data_acknowledge();
		repeat(10) @(negedge vif.i2c_scl);
		vif.i2c_sda <= 0;
		//$display("DRIVER: DATA_ACK STATE");
	endtask

	virtual task drive_stop();
		vif.stop <=1;
		//$display("DRIVER: STOP STATE");
	endtask


endclass
