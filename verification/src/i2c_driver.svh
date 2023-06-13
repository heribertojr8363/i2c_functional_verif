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
	i2c_agent_config cfg;
	i2c_sequence_item tr;
	//bit stop_scl;
	rand bit ack_addr, ack_data, rw_logic;

	function new(string name = "i2c_driver", uvm_component parent = null);
			super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(virtual i2c_interface)::get(this, "", "i2c_vif", vif)) begin
			`uvm_fatal("NOVIF", "failed to get virtual interface")
			end
	endfunction : build_phase

	task reset_phase(uvm_phase phase);
    	phase.raise_objection(this);
    	@(posedge vif.reset);

    	//Reset write data channel   
    	vif.start  <= '0;  
    	vif.stop   <= '0;
    	vif.rw   <= '0;
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

			send_start();
			if(!vif.i2c_sda) @(negedge vif.i2c_sda);
			fork
				send_addr();
				send_rw();
				set_addr_acknowledge();
			join
				
			@(negedge vif.i2c_scl);
	
			fork
				send_data();
				set_data_acknowledge();
			join

			seq_item_port.item_done();
		end
  endtask

	virtual task send_start();
		@(posedge vif.clk);
		vif.start <= 1;
	endtask

	virtual task send_addr();
		foreach (tr.addr[i]) begin
			@(negedge vif.i2c_scl);
			vif.addr[6-i] <= tr.addr[6-i];
		end
	endtask

	virtual task send_data();
		foreach (tr.w_data[i])begin
			@(negedge vif.i2c_scl);
			vif.w_data[7-i] <= tr.w_data[7-i];
		end
	endtask

	virtual task send_rw();
		repeat(8) @(negedge vif.i2c_scl);
		vif.rw <= rw_logic;
	endtask

	virtual task set_addr_acknowledge();
		repeat(10) @(negedge vif.i2c_scl);
		vif.i2c_sda <= ack_addr;
	endtask

	virtual task set_data_acknowledge();
		repeat(9) @(negedge vif.i2c_scl);
		vif.i2c_sda <= ack_data;
	endtask

	/*task scl_gen();
		repeat(9) begin
			repeat(cfg.clk_divider) @(posedge vif.clk) vif.scl = ~vif.scl;
		end
	endtask*/

	virtual task send_stop();
		@(posedge vif.clk);
		vif.stop <=1;
	endtask


endclass
