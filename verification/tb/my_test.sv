class my_test extends uvm_test;
    `uvm_component_utils(my_test)

    i2c_sequence seq;
    my_env env;
    //int cycles = 10;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq = i2c_sequence::type_id::create("seq", this);
        env = my_env::type_id::create("env", this);
    endfunction

    task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.i2c_agt.sqr);
        phase.drop_objection(this);
    endtask

endclass
