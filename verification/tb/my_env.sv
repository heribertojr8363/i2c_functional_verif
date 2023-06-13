class my_env extends uvm_env;
    `uvm_component_utils(my_env)

    i2c_agent       agt;


    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = i2c_agent::type_id::create("agt", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
endclass
