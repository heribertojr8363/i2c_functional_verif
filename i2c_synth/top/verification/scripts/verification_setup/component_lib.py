######################################################################
#  Project           : Automatic Testbench Ceator
# 
#  File Name         : component_lib.py
# 
#  Author            : Jose Iuri B. de Brito (XMEN LAB), Matheus Maciel de Sousa (XMEN LAB)
# 
#  Purpose           : This File is used to generate the components
#                      classes of the componnent. This file contains
#                      many popular components.    
######################################################################

import os
import sys
from colorama import Fore
import pathlib as path
import pandas as pd
import types as taa
    

def axi4lite_master_component(tb_path):
    #TYPES
    
    types = """package axi4_lite_types;

  typedef enum logic [1:0] {{
    AXI4_RESP_L_OKAY,
    AXI4_RESP_L_EXOKAY, // not supported on AXI4-Lite
    AXI4_RESP_L_SLVERR,
    AXI4_RESP_L_DECERR
  }} axi4_resp_el;
  
  typedef enum bit [1:0] {{
    AXI4_RESP_B_OKAY,
    AXI4_RESP_B_EXOKAY, // not supported on AXI4-Lite
    AXI4_RESP_B_SLVERR,
    AXI4_RESP_B_DECERR
  }} axi4_resp_eb;
  
  typedef struct packed {{
    logic instruction;
    logic non_secure;
    logic privileged;
  }} axi4_prot_typel;    
  
  typedef struct packed {{
    bit instruction;
    bit non_secure;
    bit privileged;
 }} axi4_prot_typeb;

endpackage"""

    file = tb_path / """axi4_lite_types.svh"""
    file1 = open(file,"a+")
    file1.write(types)
    file1.close()
    print("Vixe! Ainda nao fiz o exercicio!aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

#INTERFACE

    interface_s = """iinterface axi4_lite_if #(int ADDR_SIZE = 24, int DATA_SIZE = 32) (
    input logic ACLK,
    input logic ARESETn);

    //Memoria 4K = (1k 32bits = 2¹⁰ 4bytes)

    import axi4_types::*;
    
    localparam STRB_SIZE = (DATA_SIZE/8); //Quantidade de bytes que o data possui

    //Write Address Channel             MASTER      SLAVE
    logic awvalid;                  //  output      input               
    logic awready;                  //  input       output
    logic [ADDR_SIZE-1:0]awaddr;            //  output      input
    logic [2:0]awprot;              //  output      input

    //Write Data Channel                MASTER      SLAVE
    logic wvalid;                   //  output      input
    logic wready;                   //  input       output
    logic [DATA_SIZE-1:0]wdata;         //  output      input
    logic [STRB_SIZE-1:0]wstrb;         //  output      input

    //Write Response Channel            MASTER      SLAVE
    logic bvalid;                   //  input       output
    logic bready;                   //  output      input
    logic [1:0] bresp;              //  input       output

    //Read Address Channel              MASTER      SLAVE
    logic arvalid;                  //  output      input
    logic arready;                  //  input       output
    logic [ADDR_SIZE-1:0]araddr;            //  output      input
    logic [2:0]arprot;              //  output      input

    //Read Data Channel             MASTER      SLAVE
    logic rvalid;                   //  input       output
    logic rready;                   //  output      input
    logic [DATA_SIZE-1:0]rdata;         //  input       output
    logic [1:0] rresp;              //  input       output

    modport master(
      input   ACLK,
      input   ARESETn,

      output  awvalid,          
      input   awready,          
      output  awaddr,   
      output  awprot,       
                                
      output  wvalid,           
      input   wready,           
      output  wdata,    
      output  wstrb,    
                                
      input   bvalid,           
      output  bready,           
      input   bresp,        
                                
      output  arvalid,          
      input   arready,          
      output  araddr,   
      output  arprot,       
                                
      input   rvalid,           
      output  rready,           
      input   rdata,    
      input   rresp
    );

    modport slave(
      input   ACLK,
      input   ARESETn,

      input   awvalid,          
      output  awready,          
      input   awaddr,   
      input   awprot,       
                                
      input   wvalid,           
      output  wready,           
      input   wdata,    
      input   wstrb,    
                                
      output  bvalid,           
      input   bready,           
      output  bresp,        
                                
      input   arvalid,          
      output  arready,          
      input   araddr,   
      input   arprot,       
                                
      output  rvalid,           
      input   rready,           
      output  rdata,    
      output  rresp
    );

/*  
    modport master (
        awvalid, 
        awready, 
        awaddr, 
        awprot, 

        wvalid, 
        wready, 
        wdata, 
        wstrb, 

        bvalid, 
        bready, 
        bresp, 

        arvalid, 
        arready, 
        araddr, 
        arprot, 
        
        rvalid, 
        rready, 
        rdata, 
        rresp);
    
    modport rom (
        awvalid, 
        awready, 
        awaddr, 
        awprot, 
        
        arvalid, 
        arready, 
        araddr, 
        arprot, 
        
        rvalid, 
        rready, 
        rdata, 
        rresp);
        
    modport ram (
        awvalid, 
        awready, 
        awaddr, 
        awprot, 

        wvalid, 
        wready, 
        wdata, 
        wstrb, 

        bvalid, 
        bready, 
        bresp, 

        arvalid, 
        arready, 
        araddr, 
        arprot, 
        
        rvalid, 
        rready, 
        rdata, 
        rresp);*/
endinterface : axi4_lite_if"""

    file = tb_path / """axi4_lite_if.sv"""
    file1 = open(file,"a+")
    file1.write(interface_s)
    file1.close()

#TRANSACTION
    transaction = """class axi4_lite_slave_transaction #(int DATA_WIDTH = 32, int ADDR_SIZE = 32) extends uvm_sequence_item;
    bit read;
    bit[ADDR_SIZE-1:0] addr;
    axi4_prot_typeb prot;
    rand bit[DATA_WIDTH-1:0] data;
    bit[DATA_WIDTH/8-1:0] wstrb;
    rand axi4_resp_eb resp;

    constraint lite_constraints {{
        // AXI spec, section B1.1.1 "Signal list":
        // "The EXOKAY response is not supported on the read data and write response channels."
        resp != AXI4_RESP_B_EXOKAY;
    }}

    //rand logic [9:0] delay;
    function new(string name = "");
        super.new(name);
    endfunction

    `uvm_object_param_utils_begin(axi4_lite_slave_transaction #(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)))
        `uvm_field_int(read, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(prot, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(wstrb, UVM_ALL_ON)
        `uvm_field_enum(axi4_resp_eb, resp, UVM_ALL_ON)
    `uvm_object_utils_end

    function string convert2string();
        return $sformatf("{{read = \%b, addr = \%h, prot = \%b, data = \%h, wstrb = \%b, resp = \%s}}",
            read, addr, prot, data, wstrb, resp.name());
    endfunction
endclass""" 

    file = tb_path / """axi4_lite_master_transaction.sv"""
    file1 = open(file,"a+")
    file1.write(transaction)
    file1.close()

#DRIVER
    driver = """class axi4_lite_master_driver #(int DATA_WIDTH = 32, int ADDR_SIZE = 32)
    extends uvm_driver#(axi4_lite_master_transaction#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)));
    `uvm_component_param_utils(axi4_lite_master_driver #(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)))

    typedef virtual axi4_lite_if#(.DATA_SIZE(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) dut_vif_type;
    typedef axi4_lite_master_transaction#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) tr_type;
    typedef enum {{WAIT_ADDR, WAIT_DATA, WAIT_RESP}} state_rw;

    dut_if_type dut_vif;
    tr_type tr;
    bit item_done;
    state_rw state;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(dut_vif_type)::get(this, "", "dut_vif", dut_vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase (uvm_phase phase);
        logic reset;

        forever begin
            @(posedge dut_vif.ACLK) begin

                item_done = 1'b0;
                reset = !dut_vif.ARESETn;

                if(!dut_vif.ARESETn) begin
                    dut_vif.araddr <= '0;
                    dut_vif.arprot <= '0;
                    dut_vif.arvalid <= 0;
                    dut_vif.rready <= '1;
                    dut_vif.awvalid <= 0;
                    dut_vif.awaddr <= '0;
                    dut_vif.awprot <= '0;
                    dut_vif.wdata <= '0;
                    dut_vif.wstrb <= '1;
                    dut_vif.wvalid <= 0;
                    dut_vif.bready <= '1;
                    item_done = tr != null;
                    state = WAIT_ADDR;
                end
                else begin
                    unique case(state)
                        WAIT_ADDR: begin
                            if (tr) begin
                                if(tr.read) begin
                                    dut_vif.araddr <= tr.addr;
                                    dut_vif.arprot <= tr.prot;
                                    dut_vif.arvalid <= 1;
                                    `uvm_info("MASTER_READ", $sformatf("O master pegou o endereco de leitura da transacao: \%h",tr.addr), UVM_HIGH);
                                    `uvm_info("MASTER_READ", $sformatf("Slave de leitura: \%d", tr.addr[11:10]), UVM_HIGH);
                                    if (dut_vif.arvalid && dut_vif.arready) begin
                                        dut_vif.arvalid <= 1'b0;
                                        state = WAIT_DATA;
                                    end
                                end
                                else begin
                                    if (!dut_vif.awvalid) begin
                                        dut_vif.awaddr <= tr.addr;
                                        dut_vif.awprot <= tr.prot;
                                        dut_vif.awvalid <= '1;
                                        `uvm_info("MASTER_WRITE", $sformatf("O master pegou o endereco de escrita da transacao: \%h",tr.addr), UVM_HIGH);
                                        `uvm_info("MASTER_WRITE", $sformatf("Slave de escrita: \%d", tr.addr[11:10]), UVM_HIGH);
                                    end
                                    if (!dut_vif.wvalid) begin
                                        dut_vif.wvalid <= 1;
                                        dut_vif.wdata <= tr.data;
                                        dut_vif.wstrb <= tr.wstrb;
                                        `uvm_info("MASTER_WRITE", $sformatf("O master pegou o dado de escrita da transacao: \%h",tr.data), UVM_HIGH);
                                    end
                                    if (dut_vif.awvalid && dut_vif.awready) begin
                                        dut_vif.awvalid <= 1'b0;
                                        if (dut_vif.wvalid && dut_vif.wready) begin
                                            dut_vif.wvalid <= 1'b0;
                                            state = WAIT_RESP;
                                        end
                                        else begin
                                            state = WAIT_DATA;
                                        end
                                    end
                                end
                            end
                            else begin // (!tr)
                            end
                        end

                        WAIT_DATA: begin
                            if (tr.read) begin
                                if (dut_vif.rvalid && dut_vif.rready) begin
                                    tr.data = dut_vif.rdata;
                                    tr.resp = axi4_resp_eb'(dut_vif.rresp);
                                    item_done = '1;
                                    `uvm_info("MASTER_READ", $sformatf("Dado foi escrito no canal de leitura: \%h",dut_vif.rdata), UVM_HIGH);
                                    `uvm_info("MASTER_READ", $sformatf("Dado escrito na transacao: \%h", tr.data), UVM_HIGH);
                                    `uvm_info("MASTER_READ", $sformatf("Endereco de leitura: \%h", dut_vif.araddr), UVM_HIGH);
                                    `uvm_info("MASTER_READ", $sformatf("Slave de leitura: \%d", dut_vif.araddr[11:10]), UVM_HIGH);
                                    `uvm_info("MASTER_READ", $sformatf("Resp: \%s", tr.resp.name()), UVM_HIGH);
                                    state = WAIT_ADDR;
                                end
                            end
                            else begin
                                if (dut_vif.wvalid && dut_vif.wready) begin
                                    dut_vif.wvalid <= 1'b0;
                                    state = WAIT_RESP;
                                end
                            end
                        end

                        WAIT_RESP: begin
                            if(dut_vif.bvalid && dut_vif.bready) begin
                                tr.resp = axi4_resp_eb'(dut_vif.bresp);
                                item_done = '1;
                                //uvm_info("MASTER_WRITE", $sformatf("Item de escrita feito. Resp: \%s", dut_vif.bresp.name()), UVM_HIGH);
                                state = WAIT_ADDR;
                            end
                        end
                    endcase
                end

                if (item_done) begin
                    `uvm_info("ITEM_DONE", $sformatf("Item done."), UVM_HIGH);
                    seq_item_port.item_done();
                end
                if ((item_done || !tr) && !reset) begin
                    seq_item_port.try_next_item(tr);
                end
            end
        end
    endtask

endclass"""

    file = tb_path / """axi4_lite_master_driver.sv"""
    file1 = open(file,"a+")
    file1.write(driver)
    file1.close()

#MONITOR

    monitor = """class axi4_lite_master_monitor #(int DATA_WIDTH = 32, int ADDR_SIZE = 32) extends uvm_monitor;
    `uvm_component_param_utils(axi4_lite_master_monitor#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)))

    typedef axi4_lite_master_transaction #(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) master_transaction_type;
    typedef virtual axi4_lite_if#(.DATA_SIZE(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) dut_if_type;

    uvm_analysis_port#(master_transaction_type) req_tr_port;
    uvm_analysis_port#(master_transaction_type) resp_tr_port;
    master_transaction_type tr;

    dut_if_type dut_if;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(dut_if_type)::get(this, "", "dut_if", dut_if)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end

        req_tr_port = new("req_tr_port", this);
        resp_tr_port = new("resp_tr_port", this);

    endfunction

    task run_phase(uvm_phase phase);
        forever begin

            @(posedge dut_if.ACLK) begin
                if (!dut_if.ARESETn) begin
                    if (tr) begin
                        // abort
                        end_tr(tr);
                        // TODO: tr.abort = 1'b1; resp_tr_port.write(tr);
                    end
                end
                if (dut_if.arvalid && dut_if.arready) begin
                    tr = master_transaction_type::type_id::create("tr");
                    begin_tr(tr, "req");
                    tr.read = 1'b1;
                    tr.addr = dut_if.araddr;
                    tr.prot = dut_if.arprot;
                    end_tr(tr);
                    begin_tr(tr, "rsp");
                    req_tr_port.write(tr);
                end
                if (dut_if.rvalid && dut_if.rready) begin
                    tr.read = 1'b1;
                    tr.data = dut_if.rdata;
                    tr.resp = axi4_resp_eb'(dut_if.rresp);
                    end_tr(tr);
                    resp_tr_port.write(tr);
                end
                if (dut_if.awvalid && dut_if.awready) begin
                    tr = master_transaction_type::type_id::create("tr");
                    begin_tr(tr, "req");
                    tr.read = 1'b0;
                    tr.addr = dut_if.awaddr;
                    tr.prot = dut_if.awprot;

                end
                if (dut_if.wvalid && dut_if.wready) begin
                    tr.data = dut_if.wdata;
                    tr.wstrb = dut_if.wstrb;
                    end_tr(tr);
                    begin_tr(tr, "rsp");
                    req_tr_port.write(tr);
                end
                if (dut_if.bvalid && dut_if.bready) begin
                    tr.resp = axi4_resp_eb'(dut_if.bresp);
                    end_tr(tr);
                    resp_tr_port.write(tr);
                end
            end
        end
    endtask

endclass"""

    file = tb_path / """axi4_lite_master_monitor"""
    file1 = open(file,"a+")
    file1.write(monitor)
    file1.close()

#AGENT
    
    agent = """class axi4_lite_master_agent#(int DATA_WIDTH = 32, int ADDR_SIZE = 32) extends uvm_agent;
    `uvm_component_param_utils(axi4_lite_master_agent#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)))

    typedef axi4_lite_master_transaction#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) master_transaction_type;
    typedef uvm_sequencer#(master_transaction_type) master_sequencer;
    typedef axi4_lite_master_driver#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) master_driver_type;
    typedef axi4_lite_master_monitor#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) master_monitor_type;

    uvm_analysis_port#(master_transaction_type) agt_resp_port;
    uvm_analysis_port#(master_transaction_type) agt_req_port;


    master_sequencer sequencer;
    master_driver_type driver;
    master_monitor_type monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt_resp_port = new("agt_resp_port", this);
        agt_req_port = new("agt_req_port", this);


        sequencer = master_sequencer::type_id::create("sequencer", this);
        driver = master_driver_type::type_id::create("driver", this);
        monitor = master_monitor_type::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.resp_tr_port.connect(agt_resp_port);
        monitor.req_tr_port.connect(agt_req_port);
    endfunction

endclass"""

    file = tb_path / """axi4_lite_master_agent.sv"""
    file1 = open(file,"a+")
    file1.write(agent)
    file1.close()

def axi4lite_slave_component(tb_path):
    #TYPES
    types = """package axi4_lite_types;

  typedef enum logic [1:0] {{
    AXI4_RESP_L_OKAY,
    AXI4_RESP_L_EXOKAY, // not supported on AXI4-Lite
    AXI4_RESP_L_SLVERR,
    AXI4_RESP_L_DECERR
  }} axi4_resp_el;
  
  typedef enum bit [1:0] {{
    AXI4_RESP_B_OKAY,
    AXI4_RESP_B_EXOKAY, // not supported on AXI4-Lite
    AXI4_RESP_B_SLVERR,
    AXI4_RESP_B_DECERR
  }} axi4_resp_eb;
  
  typedef struct packed {{
    logic instruction;
    logic non_secure;
    logic privileged;
  }} axi4_prot_typel;    
  
  typedef struct packed {{
    bit instruction;
    bit non_secure;
    bit privileged;
  }} axi4_prot_typeb;

endpackage"""

    file = tb_path / """axi4_lite_types.svh"""
    file1 = open(file,"a+")
    file1.write(types)
    file1.close()

#INTERFACE

    interface_s = """interface axi4_lite_if #(int ADDR_SIZE = 24, int DATA_SIZE = 32) (
    input logic ACLK,
    input logic ARESETn);

    //Memoria 4K = (1k 32bits = 2¹⁰ 4bytes)

    import axi4_types::*;
    
    localparam STRB_SIZE = (DATA_SIZE/8); //Quantidade de bytes que o data possui

    //Write Address Channel             MASTER      SLAVE
    logic awvalid;                  //  output      input               
    logic awready;                  //  input       output
    logic [ADDR_SIZE-1:0]awaddr;            //  output      input
    logic [2:0]awprot;              //  output      input

    //Write Data Channel                MASTER      SLAVE
    logic wvalid;                   //  output      input
    logic wready;                   //  input       output
    logic [DATA_SIZE-1:0]wdata;         //  output      input
    logic [STRB_SIZE-1:0]wstrb;         //  output      input

    //Write Response Channel            MASTER      SLAVE
    logic bvalid;                   //  input       output
    logic bready;                   //  output      input
    logic [1:0] bresp;              //  input       output

    //Read Address Channel              MASTER      SLAVE
    logic arvalid;                  //  output      input
    logic arready;                  //  input       output
    logic [ADDR_SIZE-1:0]araddr;            //  output      input
    logic [2:0]arprot;              //  output      input

    //Read Data Channel             MASTER      SLAVE
    logic rvalid;                   //  input       output
    logic rready;                   //  output      input
    logic [DATA_SIZE-1:0]rdata;         //  input       output
    logic [1:0] rresp;              //  input       output

    modport master(
      input   ACLK,
      input   ARESETn,

      output  awvalid,          
      input   awready,          
      output  awaddr,   
      output  awprot,       
                                
      output  wvalid,           
      input   wready,           
      output  wdata,    
      output  wstrb,    
                                
      input   bvalid,           
      output  bready,           
      input   bresp,        
                                
      output  arvalid,          
      input   arready,          
      output  araddr,   
      output  arprot,       
                                
      input   rvalid,           
      output  rready,           
      input   rdata,    
      input   rresp
    );

    modport slave(
      input   ACLK,
      input   ARESETn,

      input   awvalid,          
      output  awready,          
      input   awaddr,   
      input   awprot,       
                                
      input   wvalid,           
      output  wready,           
      input   wdata,    
      input   wstrb,    
                                
      output  bvalid,           
      input   bready,           
      output  bresp,        
                                
      input   arvalid,          
      output  arready,          
      input   araddr,   
      input   arprot,       
                                
      output  rvalid,           
      input   rready,           
      output  rdata,    
      output  rresp
    );

/*  
    modport master (
        awvalid, 
        awready, 
        awaddr, 
        awprot, 

        wvalid, 
        wready, 
        wdata, 
        wstrb, 

        bvalid, 
        bready, 
        bresp, 

        arvalid, 
        arready, 
        araddr, 
        arprot, 
        
        rvalid, 
        rready, 
        rdata, 
        rresp);
    
    modport rom (
        awvalid, 
        awready, 
        awaddr, 
        awprot, 
        
        arvalid, 
        arready, 
        araddr, 
        arprot, 
        
        rvalid, 
        rready, 
        rdata, 
        rresp);
        
    modport ram (
        awvalid, 
        awready, 
        awaddr, 
        awprot, 

        wvalid, 
        wready, 
        wdata, 
        wstrb, 

        bvalid, 
        bready, 
        bresp, 

        arvalid, 
        arready, 
        araddr, 
        arprot, 
        
        rvalid, 
        rready, 
        rdata, 
        rresp);*/
endinterface : axi4_lite_if"""

    file = tb_path / """axi4_lite_if.sv"""
    file1 = open(file,"a+")
    file1.write(interface_s)
    file1.close()

#TRANSACTION
    transaction = """class axi4_lite_slave_transaction #(int DATA_WIDTH = 32, int ADDR_SIZE = 32) extends uvm_sequence_item;
    bit read;
    bit[ADDR_SIZE-1:0] addr;
    axi4_prot_typeb prot;
    rand bit[DATA_WIDTH-1:0] data;
    bit[DATA_WIDTH/8-1:0] wstrb;
    rand axi4_resp_eb resp;

    constraint lite_constraints {{
        // AXI spec, section B1.1.1 "Signal list":
        // "The EXOKAY response is not supported on the read data and write response channels."
        resp != AXI4_RESP_B_EXOKAY;
    }}

    //rand logic [9:0] delay;
    function new(string name = "");
        super.new(name);
    endfunction

    `uvm_object_param_utils_begin(axi4_lite_slave_transaction #(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)))
        `uvm_field_int(read, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(prot, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(wstrb, UVM_ALL_ON)
        `uvm_field_enum(axi4_resp_eb, resp, UVM_ALL_ON)
    `uvm_object_utils_end

    function string convert2string();
        return $sformatf("{{read = \%b, addr = \%h, prot = \%b, data = \%h, wstrb = \%b, resp = \%s}}",
            read, addr, prot, data, wstrb, resp.name());
    endfunction
endclass"""

    file = tb_path / """axi4_lite_master_transaction.sv"""
    file1 = open(file,"a+")
    file1.write(transaction)
    file1.close()

#DRIVER
    driver = """class axi4_lite_slave_driver #(int DATA_WIDTH = 32, int ADDR_SIZE = 32)
    extends uvm_driver#(axi4_lite_slave_transaction #(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)));
    `uvm_component_param_utils(axi4_lite_slave_driver #(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)))

    typedef virtual axi4_lite_if#(.DATA_SIZE(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) dut_vif_type;
    typedef axi4_lite_slave_transaction#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) tr_type;
    typedef enum {WAIT_ADDR, WAIT_RDATA, WAIT_WDATA, WAIT_RESP} state_rw;

    dut_vif_type dut_vif;
    tr_type tr;
    state_rw state;
    bit req_done;
    bit rsp_done;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(dut_vif_type)::get(this, "", "dut_vif", dut_vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction

    task run_phase (uvm_phase phase);
        logic reset;
        bit item_done;
        forever begin

            @(posedge dut_vif.ACLK) begin

                req_done = 1'b0;
                rsp_done = 1'b0;
                reset = !dut_vif.ARESETn;

                if(!dut_vif.ARESETn) begin
                    dut_vif.arready <= 1'b0;
                    dut_vif.rdata <= '0;
                    dut_vif.rvalid <= '0;
                    dut_vif.awready <= 1'b0;
                    dut_vif.bvalid <= 0;
                    dut_vif.wready <= 1'b1;
                    dut_vif.bresp <= AXI4_RESP_L_OKAY;
                    dut_vif.rresp <= AXI4_RESP_L_OKAY;
                    req_done = 1'b0;
                    rsp_done = 1'b0;
                    state = WAIT_ADDR;
                end
                else begin
                    // axready => (tr != null);
                    unique case(state)
                        WAIT_ADDR: begin
                            if (dut_vif.arvalid && dut_vif.arready) begin
                                tr.read = 1'b1;
                                tr.addr = dut_vif.araddr;
                                tx.prot = dut_vif.arprot;
                                req_done = 1'b1;
                                state = WAIT_RDATA;
                            end
                            else if (dut_vif.awvalid && dut_vif.awready) begin
                                tx.read = 1'b0;
                                tx.addr = dut_vif.awaddr;
                                tx.prot = dut_vif.awprot;
                                if (dut_vif.wvalid && dut_vif.wready) begin
                                    tx.data = dut_vif.wdata;
                                    tx.wstrb = dut_vif.wstrb;
                                    req_done = 1'b1;
                                    state = WAIT_RESP;
                                end
                                else begin
                                    state = WAIT_WDATA;
                                end
                            end
                        end

                        WAIT_RDATA: begin
                            // rvalid => (tx != null)
                            if (dut_vif.rvalid && dut_vif.rready) begin
                                dut_vif.rvalid <= 1'b0;
                                rsp_done = 1'b1;
                                state = WAIT_ADDR;
                            end
                        end

                        WAIT_WDATA: begin
                            if (dut_vif.wvalid && dut_vif.wready) begin
                                tx.data = dut_vif.wdata;
                                tx.wstrb = dut_vif.wstrb;
                                req_done = 1'b1;
                                state = WAIT_RESP;
                            end
                        end

                        WAIT_RESP: begin
                            // bvalid => (tx != null)
                            if (dut_vif.bvalid && dut_vif.bready) begin
                                dut_vif.bvalid <= 1'b0;
                                rsp_done = 1'b1;
                                state = WAIT_ADDR;
                            end
                        end
                    endcase
                end

                item_done = req_done || rsp_done;
                if (item_done) begin
                    `uvm_info("ITEM_DONE", $sformatf("Item done."), UVM_HIGH);
                    seq_item_port.item_done();
                end
                if ((item_done || !tx) && !reset) begin
                    seq_item_port.try_next_item(tx);
                    unique case(state)
                        WAIT_ADDR: begin
                            dut_vif.arready <= (tx != null);
                            dut_vif.awready <= (tx != null);
                        end

                        WAIT_RDATA: begin
                            dut_vif.rvalid <= (tx != null);
                            dut_vif.rdata <= (tx != null) ? tx.data : 'x;
                            dut_vif.rresp <= axi4_resp_el'((tx != null) ? tx.resp : 'x);
                            `uvm_info("SLAVE_READ", $sformatf("Dado: \%h || Resp: \%s", tx.data, tx.resp.name()), UVM_HIGH);
                        end

                        WAIT_WDATA: begin
                        end

                        WAIT_RESP: begin
                            dut_vif.bvalid <= (tx != null);
                            dut_vif.bresp <= axi4_resp_el'((tx != null) ? tx.resp : 'x);
                            `uvm_info("SLAVE_WRITE", $sformatf("Dado: \%h || Resp: \%s", dut_vif.wdata, tx.resp.name()), UVM_HIGH);
                        end
                    endcase
                end
            end
        end
    endtask

endclass"""

    file = tb_path / """axi4_lite_slave_driver.sv"""
    file1 = open(file,"a+")
    file1.write(driver)
    file1.close()

#MONITOR

    monitor = """class axi4_lite_slave_monitor #(int DATA_WIDTH = 32, int ADDR_SIZE = 32) extends uvm_monitor;
    `uvm_component_param_utils(axi4_lite_slave_monitor#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)))

    typedef axi4_lite_slave_transaction #(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) slave_transaction_type;
    typedef virtual axi4_lite_if#(.DATA_SIZE(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) dut_vif_type;

    uvm_analysis_port#(slave_transaction_type) req_tr_port
    slave_transaction_type tr;

    dut_vif_type dut_vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(dut_vif_type)::get(this, "", "dut_vif", dut_vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end

        req_tr_port = new("req_tr_port", this);

    endfunction

    task run_phase(uvm_phase phase);
        forever begin

            @(posedge dut_vif.ACLK) begin
                if (!dut_vif.ARESETn) begin
                    if (tr) begin
                        // abort
                        end_tr(tr);
                        // TODO: tr.abort = 1'\''b1; req_tr_port.write(tr);
                    end
                end
                if (dut_vif.arvalid && dut_vif.arready) begin
                    tr = slave_transaction_type::type_id::create("tr");
                    begin_tr(tr, "monitor");
                    tr.read = 1'\''b1;
                    tr.addr = dut_vif.araddr;
                    tr.prot = dut_vif.arprot;
                end
                if (dut_vif.rvalid && dut_vif.rready) begin
                    tr.read = 1'\''b1;
                    tr.data = dut_vif.rdata;
                    tr.resp = axi4_resp_eb'\''(dut_vif.rresp);
                    end_tr(tr);
                    req_tr_port.write(tr);
                end
                if (dut_vif.awvalid && dut_vif.awready) begin
                    tr = slave_transaction_type::type_id::create("tr");
                    begin_tr(tr, "monitor");
                    tr.read = 1'\''b0;
                    tr.addr = dut_vif.awaddr;
                    tr.prot = dut_vif.awprot;
                end
                if (dut_vif.wvalid && dut_vif.wready) begin
                    tr.data = dut_vif.wdata;
                    tr.wstrb = dut_vif.wstrb;
                end
                if (dut_vif.bvalid && dut_vif.bready) begin
                    tr.resp = axi4_resp_eb'\''(dut_vif.bresp);
                    end_tr(tr);
                    req_tr_port.write(tr);
                end
            end
        end
    endtask

endclass"""

    file = tb_path / """axi4_lite_slave_monitor"""
    file1 = open(file,"a+")
    file1.write(monitor)
    file1.close()

#AGENT
    
    agent = """class axi4_lite_slave_agent #(int DATA_WIDTH = 32, int ADDR_SIZE = 32) extends uvm_agent;
    `uvm_component_param_utils(axi4_lite_slave_agent#(DATA_WIDTH, ADDR_SIZE))

    typedef axi4_lite_slave_transaction#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) slave_transaction_type;
    typedef uvm_sequencer#(slave_transaction_type) slave_sequencer;
    typedef axi4_lite_slave_driver#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) slave_driver_type;
    typedef axi4_lite_slave_monitor#(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE)) slave_monitor_type;

    uvm_analysis_port#(master_transaction_type) agt_req_port;

    // Renomear essas variaveis para sequencer, driver e monitor.
    slave_sequencer sequencer;
    slave_driver_type driver;
    slave_monitor_type monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt_req_port = new("agt_req_port", this);

        sequencer = slave_sequencer::type_id::create("sequencer", this);
        driver = slave_driver_type::type_id::create("driver", this);
        monitor = slave_monitor_type::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.req_tr_port.connect(agt_req_port);
    endfunction

endclass"""

    file = tb_path / """axi4_lite_slave_agent.sv"""
    file1 = open(file,"a+")
    file1.write(agent)
    file1.close()

def apb_master_component(tb_path):
    print(Fore.RED + "\tNão implementado")

def i2c_master_component(tb_path):
    print(Fore.RED + "\tNão implementado")

def spi_master_component(tb_path):
    print(Fore.RED + "\tNão implementado")

#GENERAL COMPONENTS GENERATOR
def uvm_general_component(interface, interface_path, tb_path):
#TYPES
    types = """`ifndef {INTERFACE}_TYPES
`define {INTERFACE}_TYPES

`endif""".format(INTERFACE=interface.upper())

    file = tb_path / """{INTERFACE}_types.svh""".format(INTERFACE=interface)
    file1 = open(file,"a+")
    file1.write(types)
    file1.close()

#INTERFACE
    df = pd.read_csv(interface_path)

    df_aux = df.drop(0)
    df_aux = df.drop(1)

    interface_s = """interface {INTERFACE}_if (input logic {CLK}, {RST});

""".format(INTERFACE=interface, CLK = df['Sinal'][1], RST = df['Sinal'][0])

    df_aux = df_aux.replace(['s', 'u','I','O'], ['signed', '', 'input', 'output'])
    df = df.replace(['s', 'u','I','O'], ['signed', '', 'input', 'output'])

    for index, row in df_aux.iterrows():
        if row['Tamanho'] == "1":
            interface_s = interface_s + """    logic {SINAL};

""".format(SINAL=row['Sinal'])
        else :
            interface_s = interface_s + """    logic {SIGNED} [{TAMANHO}-1:0] {SINAL};

""".format(SIGNED=row['Signed'], TAMANHO=row['Tamanho'], SINAL=row['Sinal'])
        

    interface_s = interface_s + """    modport port(
"""

    for index, row in df.iterrows():
        interface_s = interface_s + """        {IO}   {SINAL},
""".format(IO=row['I/O'], SINAL=row['Sinal'])

    interface_new = interface_s[:-2] + """
    );
endinterface : {INTERFACE}_if""".format(INTERFACE=interface)

    file = tb_path / """{INTERFACE}_if.sv""".format(INTERFACE=interface)
    file1 = open(file,"a+")
    file1.write(interface_new)
    file1.close()

#TRANSACTION
    transaction = """class {INTERFACE}_transaction extends uvm_sequence_item;
    rand integer A;
    rand integer B;
    //Alterar os dados para sua aplicação

    `uvm_object_utils_begin({INTERFACE}_transaction)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="{INTERFACE}_transaction");
        super.new(name);
    endfunction: new

    function string convert2string();
        return $sformatf("{{A = \%h, B = \%h}}", A, B);
    endfunction
endclass: {INTERFACE}_transaction""".format(INTERFACE=interface)

    file = tb_path / """{INTERFACE}_transaction.sv""".format(INTERFACE=interface)
    file1 = open(file,"a+")
    file1.write(transaction)
    file1.close()

#DRIVER
    driver = """class {INTERFACE}_driver extends uvm_driver#({INTERFACE}_transaction);
    `uvm_component_utils({INTERFACE}_driver)

    typedef virtual {INTERFACE}_if vif;
    typedef {INTERFACE}_transaction tr_type;
    typedef enum {{WAIT_ADDR, WAIT_DATA, WAIT_RESP}} state_rw;

    vif dut_vif;
    tr_type tr;
    bit item_done;
    event begin_record,end_record;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(vif)::get(this, "", "dut_vif", dut_vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            get_and_drive(phase);
            record_tr();
        join
    endtask

    virtual protected task reset_signals();
        wait (dut_vif.rst === 1);
        forever begin
            dut_vif.valid <= '0;
            dut_vif.A <= 'x;
            dut_vif.B <= 'x;
            @(posedge dut_vif.rst);
        end
    endtask

    virtual protected task get_and_drive(uvm_phase phase);
        wait(dut_vif.rst === 1);
        @(negedge dut_vif.rst);
        @(posedge dut_vif.clk);

        forever begin
            seq_item_port.get(req);
            -> begin_record;
            drive_transfer(req);
        end
    endtask

    virtual protected task drive_transfer({INTERFACE}_transaction tr);
        dut_vif.A = tr.A;
        dut_vif.B = tr.B;
        dut_vif.valid = 1;

        @(posedge dut_vif.clk)

        while(!dut_vif.ready)
        @(posedge dut_vif.clk);

        -> end_record;
        @(posedge dut_vif.clk); //hold time
        dut_vif.valid = 0;
        @(posedge dut_vif.clk);
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(req, "driver");
            @(end_record);
            end_tr(req);
        end
    endtask
endclass: {INTERFACE}_driver""".format(INTERFACE=interface)

    file = tb_path / """{INTERFACE}_driver.sv""".format(INTERFACE=interface)
    file1 = open(file,"a+")
    file1.write(driver)
    file1.close()

#MONITOR

    monitor = """class {INTERFACE}_monitor extends uvm_monitor;

    virtual {INTERFACE}_if  {INTERFACE}_vif;
    event begin_record, end_record;
    {INTERFACE}_transaction tr;
    uvm_analysis_port #({INTERFACE}_transaction) req_tr_port;
    uvm_analysis_port #({INTERFACE}_transaction) resp_tr_port;
    `uvm_component_utils({INTERFACE}_monitor)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        req_tr_port = new("req_tr_port", this);
        resp_tr_port = new("resp_tr_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(virtual {INTERFACE}_if)::get(this, "", "{INTERFACE}_vif", {INTERFACE}_vif));
        tr = {INTERFACE}_transaction::type_id::create("tr", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions(phase);
            record_tr();
        join
    endtask

    virtual task collect_transactions(uvm_phase phase);
        wait({INTERFACE}_vif.rst === 1);
        @(negedge {INTERFACE}_vif.rst);
        
        forever begin
            do begin
                @(posedge {INTERFACE}_vif.clk);
            end while ({INTERFACE}_vif.valid === 0 || {INTERFACE}_vif.ready === 0);
            -> begin_record;
            
            tr.A = {INTERFACE}_vif.A;
            tr.B = {INTERFACE}_vif.B;
            req_tr_port.write(tr);
            resp_tr_port.write(tr);

            @(posedge {INTERFACE}_vif.clk);
            -> end_record;
        end
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(tr, "{INTERFACE}_monitor");
            @(end_record);
            end_tr(tr);
        end
    endtask
endclass: {INTERFACE}_monitor""".format(INTERFACE=interface)

    file = tb_path / """{INTERFACE}_monitor.sv""".format(INTERFACE=interface)
    file1 = open(file,"a+")
    file1.write(monitor)
    file1.close()

#AGENT
    
    agent = """class {INTERFACE}_agent extends uvm_agent;
    uvm_sequencer#({INTERFACE}_transaction) sqr;
    {INTERFACE}_driver    drv;
    {INTERFACE}_monitor   mon;

    uvm_analysis_port #({INTERFACE}_transaction) agt_resp_port;
    uvm_analysis_port #({INTERFACE}_transaction) agt_req_port;

    `uvm_component_utils({INTERFACE}_agent)

    function new(string name = "{INTERFACE}_agent", uvm_component parent = null);
        super.new(name, parent);
        agt_resp_port = new("agt_resp_port", this);
        agt_req_port = new("agt_req_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = {INTERFACE}_monitor::type_id::create("mon", this);
        sqr = uvm_sequencer#({INTERFACE}_transaction)::type_id::create("sqr", this);
        drv = {INTERFACE}_driver::type_id::create("drv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.req_tr_port.connect(agt_req_port);
        mon.resp_tr_port.connect(agt_resp_port);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass: {INTERFACE}_agent""".format(INTERFACE=interface)

    file = tb_path / """{INTERFACE}_agent.sv""".format(INTERFACE=interface)
    file1 = open(file,"a+")
    file1.write(agent)
    file1.close()
