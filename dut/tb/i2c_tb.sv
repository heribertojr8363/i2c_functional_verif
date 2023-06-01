`timescale 1ns/1ps

module tb;

    logic clk;
    logic reset;
    logic start;
    logic [6:0] addr_in;
    logic [7:0] data_in;

    logic i2c_sda;
    logic i2c_slc;
    logic fifo_full;
    logic ready_out;

    logic i2c_clk;

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

    i2c dut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .addr(addr_in),
        .data(data_in),

        .i2c_sda(i2c_sda),
        .i2c_scl(i2c_slc),
        .ready(ready_out)
    );


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
        start = 1;
        addr_in = 7'h55;
        data_in = 8'haa;

        #300;
        

        @(negedge clk);
        start = 1;
        addr_in = 7'h55;
        data_in = 8'h01;

        #300;

        @(negedge clk);
        start = 1;
        addr_in = 7'h55;
        data_in = 8'hd3;
        
        #300;

        $finish();
    end
    
endmodule