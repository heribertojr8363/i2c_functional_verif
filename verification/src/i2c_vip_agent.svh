`ifndef I2C_VIP_AGENT
`define I2C_VIP_AGENT

class i2c_vip_agent extends uvm_agent;
    `uvm_component_utils(i2c_vip_agent)

     typedef uvm_sequencer#(i2c_vip_sequence_item) sequencer;
     sequencer  sqr;
     i2c_vip_agent_config          cfg;
     // i2c_vip_monitor               mon;
     i2c_vip_driver #(.ADDR_WIDTH(7), .DATA_WIDTH(8))            drv;

    function new(string name = "i2c_vip_agent", uvm_component parent = null);
        super.new(name, parent);
        cfg = new();
    endfunction

    function void build_phase(uvm_phase phase);

        if(cfg.is_active == UVM_ACTIVE) begin
            sqr = sequencer::type_id::create("sqr",this);
            drv = i2c_vip_driver #(.ADDR_WIDTH(7), .DATA_WIDTH(8))::type_id::create("drv",this);
            drv.cfg = this.cfg;
        end

        // mon = i2c_vip_monitor::type_id::create("mon",this);
        // mon.cfg = this.cfg;

    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction

endclass
`endif //I2C_VIP_AGENT
