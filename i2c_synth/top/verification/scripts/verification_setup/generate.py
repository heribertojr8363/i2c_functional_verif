######################################################################
#  Project           : Automatic Testbench Ceator
# 
#  File Name         : generate.py
# 
#  Author            : Jose Iuri B. de Brito (XMEN LAB),Matheus Maciel de Sousa (XMEN LAB)

# 
#  Purpose           : This File is used to generate main classes of 
#                      the architecture testbench. Also calls the 
#                      components generator.     
######################################################################

import os
import sys
from colorama import Fore
import pathlib as path
from component_lib import *


def generate(author, module, interface, interface_path, test, tb_path, passive, rtl_path):
#Calls the components generator
    if interface == 'axi4lite_master':
        axi4lite_master_component(tb_path)
    elif interface == 'axi4lite_slave':
        axi4lite_slave_component(tb_path)
    elif interface == 'apb_master':
        apb_master_component(tb_path)
    elif interface == 'i2c_master':
        i2c_master_component(tb_path)
    elif interface == 'spi_master':
        spi_master_component(tb_path)
    else:
        uvm_general_component(interface, interface_path, tb_path)


#SEQUENCE
    sequence = """class {MODULE}_sequence extends uvm_sequence #({INTERFACE}_transaction);
    `uvm_object_utils({MODULE}_sequence)

    function new(string name="{MODULE}_sequence");
        super.new(name);
    endfunction: new

    task body;
        {INTERFACE}_transaction tr;

        forever begin
            tr = {INTERFACE}_transaction::type_id::create("tr");
            start_item(tr);
                assert(tr.randomize());
            finish_item(tr);
            //Alterar caso necessite de uma sequencia direcionada.
        end
    endtask: body
endclass""".format(MODULE=module, INTERFACE=interface)

    file = tb_path / """{MODULE}_sequence.sv""".format(MODULE=module)
    file1 = open(file,"a+")
    file1.write(sequence)
    file1.close() 

#SCOREBOARD
    scoreboard = """class {MODULE}_scoreboard extends uvm_scoreboard;
    
    typedef {INTERFACE}_transaction T;
    typedef uvm_in_order_class_comparator #(T) comp_type;

    {MODULE}_refmod rfm;
    comp_type comp;

    uvm_analysis_port #(T) ap_comp;
    uvm_analysis_port #(T) ap_rfm;

    `uvm_component_utils({MODULE}_scoreboard)

    function new(string name="{MODULE}_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        ap_comp = new("ap_comp", this);
        ap_rfm = new("ap_rfm", this);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rfm = {MODULE}_refmod::type_id::create("rfm", this);
        comp = comp_type::type_id::create("comp", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        ap_comp.connect(comp.before_export);
        ap_rfm.connect(rfm.in);
        rfm.out.connect(comp.after_export);
    endfunction

endclass: {MODULE}_scoreboard""".format(MODULE=module, INTERFACE= interface)

    file = tb_path / """{MODULE}_scoreboard.sv""".format(MODULE=module)
    file1 = open(file,"a+")
    file1.write(scoreboard)
    file1.close()

#ENV
    env = """class {MODULE}_env extends uvm_env;
    typedef {INTERFACE}_agent agent_type;
    agent_type agent;
    {MODULE}_scoreboard   sb;
    {MODULE}_cover cv;
    `uvm_component_utils({MODULE}_env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = agent_type::type_id::create("agent", this);
        sb = {MODULE}_scoreboard::type_id::create("sb", this);
        cv = {MODULE}_cover::type_id::create("cv",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.agt_req_port.connect(cv.req_port);
        """.format(MODULE=module, INTERFACE=interface)

    if passive == 0:
        env = env + """        agent.agt_resp_port.connect(cv.resp_port);
        agent.agt_resp_port.connect(sb.ap_comp);
"""

    env = env + """        agent.agt_req_port.connect(sb.ap_rfm);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction

endclass: {MODULE}_env""".format(MODULE=module)

    file = tb_path / """{MODULE}_env.sv""".format(MODULE=module)
    file1 = open(file,"a+")
    file1.write(env)
    file1.close()

#REFMOD
    refmod = """class {MODULE}_refmod extends uvm_component;
    `uvm_component_utils({MODULE}_refmod)
    
    {INTERFACE}_transaction tr_in;
    {INTERFACE}_transaction tr_out;
    integer a, b;
    uvm_analysis_imp #({INTERFACE}_transaction, {MODULE}_refmod) in;
    uvm_analysis_export #({INTERFACE}_transaction) out;
    
    function new(string name = "{MODULE}_refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = {INTERFACE}_transaction::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            @begin_refmodtask;
            //tr_out.data = sum(tr_in.A, tr_in.B);
            out.write(tr_out);
        end
    endtask: run_phase

    virtual function write ({INTERFACE}_transaction t);
        tr_in = {INTERFACE}_transaction::type_id::create("tr_in", this);
        tr_in.copy(t);
        -> begin_refmodtask;
    endfunction
endclass: {MODULE}_refmod""".format(MODULE=module, INTERFACE=interface)

    file = tb_path / """{MODULE}_refmod.sv""".format(MODULE=module)
    file1 = open(file,"a+")
    file1.write(refmod)
    file1.close()

#COVERAGE
    cover = """`uvm_analysis_imp_decl(_req)
`uvm_analysis_imp_decl(_resp)

class {MODULE}_cover extends uvm_component;
    `uvm_component_utils({MODULE}_cover)

    {INTERFACE}_transaction req;
""".format(MODULE=module, INTERFACE=interface)
    
    if passive == 0:
        cover = cover + """    {INTERFACE}_transaction resp;
""".format(MODULE=module, INTERFACE=interface)
    
    cover = cover + """
    uvm_analysis_imp_req#({INTERFACE}_transaction, {MODULE}_cover) req_port;
""".format(MODULE=module, INTERFACE=interface)
    
    if passive == 0:
        cover = cover + """    uvm_analysis_imp_resp#({INTERFACE}_transaction, {MODULE}_cover) resp_port;
""".format(MODULE=module, INTERFACE=interface)

    cover = cover + """    int min_cover = 100;
    int min_transa = 5120;
    int transa = 0;

    function new(string name = "{MODULE}_cover", uvm_component parent= null);
        super.new(name, parent);
        req_port = new("req_port", this);""".format(MODULE=module)

    if passive == 0:
        cover = cover + """        resp_port = new("resp_port", this);
        resp=new;"""

    cover = cover + """        req=new;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase (phase);
        uvm_config_db#(int)::get(this, "", "min_cover", min_cover);
        uvm_config_db#(int)::get(this, "", "min_transa", min_transa);
    endfunction

    protected uvm_phase running_phase;
    task run_phase(uvm_phase phase);
        running_phase = phase;
        running_phase.raise_objection(this);"""

    if passive == 0:
        cover = cover + """        running_phase.raise_objection(this);"""
        
    cover = cover + """    endtask: run_phase

//============= Função para copiar transações do agent (Requisições) ======================
    function void write_req({INTERFACE}_transaction t);
        req.copy (t);
        //req_cover.sample();
        transa = transa + 1;
        $display("transa:%d",transa);
        $display("min_transa:%d",min_transa);
        if(transa >= min_transa)begin
    $display("dropou");
    running_phase.drop_objection(this);
    end
    //if($get_coverage() >= min_cover)
    //  running_phase.drop_objection(this);

    endfunction: write_req
""".format(INTERFACE=interface)

    if passive == 0:
        cover = cover + """//============= Função para copiar transações do agent (Respostas) ========================
    function void write_resp({INTERFACE}_transaction t);
    resp.copy(t);

    //resp_cover.sample();

    //$display("cobertura:%d",$get_coverage());
    if($get_coverage() >= min_cover)
    running_phase.drop_objection(this);

    endfunction: write_resp
""".format(INTERFACE=interface)

    cover = cover + """endclass : {MODULE}_cover""".format(MODULE=module)

    file = tb_path / """{MODULE}_cover.sv""".format(MODULE=module)
    file1 = open(file,"a+")
    file1.write(cover)
    file1.close()

#TEST
    test_c = """class {TEST_NAME} extends uvm_test;
    {MODULE}_env env_h;
    {MODULE}_sequence seq;

    `uvm_component_utils(simple_test)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = {MODULE}_env::type_id::create("env_h", this);
        seq = {MODULE}_sequence::type_id::create("seq", this);
    endfunction

    task run_phase(uvm_phase phase);
        seq.start(env_h.agent.sqr);
    endtask: run_phase

endclass: {TEST_NAME}""".format(MODULE=module, TEST_NAME=test)

    file = tb_path / """{TEST}.sv""".format(TEST=test)
    file1 = open(file,"a+")
    file1.write(test_c)
    file1.close()

#top
    top = """module top;
    import uvm_pkg::*;
    import {MODULE}_pkg::*;
    logic clk;
    logic reset;
    parameter min_cover = 70;
    parameter min_transa = 2000;

    initial begin
    clk = 0;
    reset = 1;
    #22 reset = 1;
    #1  reset = 0;
    end

    always #5 clk = !clk;

    {INTERFACE}_if {INTERFACE}_vif (.clk(clk), .reset(reset));

    {MODULE}_wrapper DUT (.bus({INTERFACE}_vif));

    initial begin
    `ifdef XCELIUM
       $recordvars();
    `endif
    `ifdef VCS
       $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif

    uvm_config_db#(virtual {INTERFACE}_if)::set(uvm_root::get(), "*", "dut_vif", {INTERFACE}_vif);
    uvm_config_db#(int)::set(uvm_root::get(),"*", "min_cover", min_cover);
    uvm_config_db#(int)::set(uvm_root::get(),"*", "min_transa", min_transa);
    run_test("{TEST_NAME}");
    end
endmodule""".format(MODULE=module, INTERFACE=interface, TEST_NAME=test)

    file = tb_path / """top.sv"""
    file1 = open(file,"a+")
    file1.write(top)
    file1.close()

#PKG
    pkg = """package {MODULE}_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;


    `include "./{INTERFACE}_types.svh"
    `include "./{INTERFACE}_transaction.sv"
    
    `include "./{MODULE}_sequence.sv"
    `include "./{INTERFACE}_driver.sv"
    `include "./{INTERFACE}_monitor.sv"
    `include "./{INTERFACE}_agent.sv"

    `include "./{MODULE}_cover.sv"
    `include "./{MODULE}_refmod.sv"
    `include "./{MODULE}_scoreboard.sv"
    `include "./{MODULE}_env.sv"

    `include "./{TEST_NAME}.sv"
endpackage""".format(MODULE=module, INTERFACE=interface, TEST_NAME=test, RTL_PATH=rtl_path)

    file = tb_path / """{MODULE}_pkg.sv""".format(MODULE=module)
    file1 = open(file,"a+")
    file1.write(pkg)
    file1.close()

#MAKEFILE
    make = """RTL_SRC = ./{RTL_PATH}
MODEL_SRC = ./
WRAPPER = ./{MODULE}_wrapper.sv

IF = {INTERFACE}_if.sv
RTL = 
REFMOD = 
PKGS = ./{MODULE}_pkg.sv 

SEED = 100
COVER = 100
TRANSA = 5000

RUN_ARGS_COMMON = -access +r -input shm.tcl \\
          +uvm_set_config_int=*,recording_detail,1 -coverage all -covoverwrite

sim:
    @xrun -64bit -uvm  +incdir+$(RTL_SRC) $(PKGS) $(IF) $(RTL) $(WRAPPER) top.sv \\
    +UVM_TESTNAME={TEST_NAME} -covtest {TEST_NAME}-$(SEED) -svseed $(SEED)  \\
    -defparam top.min_cover=$(COVER) -defparam top.min_transa=$(TRANSA) $(RUN_ARGS_COMMON) $(RUN_ARGS)


clean:
    @rm -rf INCA_libs waves.shm rtlsim/* *.history *.log rtlsim/* *.key mdv.log imc.log imc.key ncvlog_*.err *.trn *.dsn .simvision/ xcelium.d simv.daidir *.so *.o *.err

rebuild: clean sim

view_waves:
    simvision waves.shm &

view_cover:
    imc &""".format(MODULE=module, INTERFACE=interface, TEST_NAME=test, RTL_PATH=rtl_path)

    file = tb_path / """Makefile"""
    file1 = open(file,"a+")
    file1.write(make)
    file1.close()
