`ifndef I2C_AGENT
`define I2C_AGENT

class i2c_agent extends uvm_agent;
    `uvm_component_utils(i2c_agent)

    uvm_analysis_port #(i2c_sequence_item) mon_ap;

     typedef uvm_sequencer#(i2c_sequence_item) sequencer;
     sequencer sqr;
     //i2c_agent_config cfg;
     i2c_monitor mon;
     i2c_driver drv;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_ap = new(.name("mon_ap"), .parent(this));
        sqr = sequencer::type_id::create("sqr",this);
        drv = i2c_driver::type_id::create("drv",this);
        mon = i2c_monitor::type_id::create("mon",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.mon_ap.connect(mon_ap);
    endfunction

endclass
`endif //I2C_AGENT
