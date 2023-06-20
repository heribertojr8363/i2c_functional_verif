class my_env extends uvm_env;
    `uvm_component_utils(my_env)

    i2c_agent       i2c_agt;
    i2c_subscriber  i2c_sub;
    i2c_scoreboard  i2c_sb;


    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i2c_agt = i2c_agent::type_id::create("i2c_agt", this);
        i2c_sub = i2c_subscriber::type_id::create("i2c_sub", this);
        i2c_sb  = i2c_scoreboard::type_id::create("i2c_sb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        i2c_agt.mon_ap.connect(i2c_sub.analysis_export);
        i2c_agt.mon_ap.connect(i2c_sb.i2c_analysis_export);
    endfunction
endclass
