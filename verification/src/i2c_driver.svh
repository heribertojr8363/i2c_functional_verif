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
class i2c_driver #(parameter ADDR_WIDTH=7, parameter DATA_WIDTH=8) extends uvm_driver #(i2c_sequence_item);
	`uvm_component_utils(i2c_driver #(.ADDR_WIDTH(7),.DATA_WIDTH(8)))

	virtual i2c_interface vif;
	i2c_agent_config cfg;
	i2c_sequence_item #(.ADDR_WIDTH(7), .DATA_WIDTH(8)) tr;
	bit stop_scl;
	bit ack;

	function new(string name = "i2c_driver", uvm_component parent = null);
			super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(virtual i2c_interface)::get(this, "", "i2c_vif", vif)) begin
			`uvm_fatal("NOVIF", "failed to get virtual interface")
			end
	endfunction : build_phase

	task run_phase (uvm_phase phase);
		@(posedge vif.rst);
		vif.scl <= 1;
		vif.sda <= 1;

		forever begin
			repeat (cfg.initial_delay_clock) @(posedge vif.clk);
			seq_item_port.get_next_item(tr);

			send_start();
			if (tr.read) begin
				fork
					scl_gen();
					begin
						send_addr();
						get_acknowledge();
					end
				join
				if(ack) begin
					repeat (cfg.byte_number) begin
						fork
							scl_gen();
							set_acknowledge();
						join
					end
				end else send_stop();
			end
			else begin
				fork
					scl_gen();
					begin
						send_addr();
						get_acknowledge();
					end
				join
				if(ack) begin
					repeat (cfg.byte_number) begin
						fork
							scl_gen();
							begin
								send_data();
								get_acknowledge();
							end
						join
							if(!ack) break;
					end
				end else send_stop();
			end
			send_stop();
		end
  endtask

	task send_start();
		vif.sda <=0;
		repeat (cfg.start_condition_post_delay) @(posedge vif.clk);
	endtask

	task send_addr();
		foreach (tr.addr[i]) begin
			@(posedge vif.scl);
			vif.sda <= tr.addr[ADDR_WIDTH-i];
			@(posedge vif.scl);
			vif.sda <= tr.read;
		end
	endtask

	task send_data();
		foreach (tr.data[i])begin
			@(posedge vif.scl);
			vif.sda <= tr.data[DATA_WIDTH-i];
		end
	endtask

	task get_acknowledge();
		@(posedge vif.scl)
		ack  = (vif.sda)? 0:1;
	endtask

	task set_acknowledge();
		repeat(9) @(posedge vif.scl);
		vif.sda <= 1;
	endtask

	task scl_gen();
		repeat(9) begin
			repeat(cfg.clk_divider) @(posedge vif.clk) vif.scl = ~vif.scl;
		end
	endtask

	task send_stop();
		vif.sda <=1;
		vif.scl <=1;
	endtask


endclass
