`timescale 1ns/1ps
`include "../../verification/src/i2c_interface.svh"

module tb;

    bit clk;
    bit reset;
    //logic fifo_full;

    //logic i2c_clk;

    /*i2c_clk_divider #(.DELAY(1000)) clk_divider(
        .reset(reset),
        .ref_clk(clk),
        .i2c_clk(i2c_clk)
    );*/

    /*i2c_fifo_master fifo_master(
        .clk_in(clk),
        .reset_in(reset),
        .start(start),
        .addr_in(addr_in),
        .data_in(data_in),
        .i2c_sda_inout(i2c_sda),
        .i2c_scl_inout(i2c_scl),
        .fifo_full(fifo_full),
        .ready_out(ready_out)
    );*/
    
    i2c_interface dut_if (.clk(clk),.reset(reset));

    i2c_master dut(dut_if);


    initial begin
        clk = 0;
        forever begin
            clk = #5 ~clk;
        end
    end
    
    initial begin
        reset = 1;

        #5;

        reset = 0;

        #5;

        @(negedge clk);
        dut_if.start = 'h1;
        dut_if.stop = 'h0;
        dut_if.rw = 'h0;
        dut_if.addr = 7'h55;
        dut_if.w_data = 8'haa;

        #300;

        dut_if.stop = 'h1;

        #50;
        

        /*@(negedge clk);
        start_in = 'h1;
        stop_in = 'h0;
        rw_in = 'h1;
        addr_in = 7'h55;
        data_in = 8'h01;

        #300;

        stop_in = 'h1;

        #50;

        @(negedge clk);
        start = 'h1;
        addr_in = 7'h55;
        data_in = 8'hd3;
        
        #300;*/

        $finish();
    end
    
endmodule
