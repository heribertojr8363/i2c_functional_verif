`timescale 1ns/1ps

module tb;

    logic clk;
    logic reset;
    logic start_in;
    logic stop_in;
    logic rw_in;
    logic [6:0] addr_in;
    logic [7:0] data_in;

    logic i2c_sda;
    logic i2c_slc;
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

    i2c_master dut(
        .clk(clk),
        .reset(reset),
        .start(start_in),
        .stop(stop_in),
        .rw(rw_in),
        .addr(addr_in),
        .w_data(data_in),
        .i2c_sda_i(i2c_sda),

        .i2c_scl(i2c_slc),
        .i2c_sda_o(i2c_sda)
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
        start_in = 'h1;
        stop_in = 'h0;
        rw_in = 'h0;
        addr_in = 7'h55;
        data_in = 8'haa;

        #200;

        stop_in = 'h1;

        #50
        

        @(negedge clk);
        start_in = 'h1;
        stop_in = 'h0;
        rw_in = 'h1;
        addr_in = 7'h55;
        data_in = 8'h01;
        i2c_sda_in = data_in;

        #200;

        stop_in = 'h1;

        #50

        /*@(negedge clk);
        start = 'h1;
        addr_in = 7'h55;
        data_in = 8'hd3;
        
        #300;*/

        $finish();
    end
    
endmodule