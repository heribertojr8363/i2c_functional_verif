`timescale 1ns/1ps

module i2c_fifo_master (
    input logic clk_in,
    input logic reset_in,
    input logic start,
    input logic [6:0] addr_in,
    input logic [7:0] data_in,

    output logic i2c_sda_inout,
    output logic i2c_scl_inout,

    output logic fifo_full,
    output logic ready_out
);

    logic [14:0] fifo_data_in;
    logic [14:0] fifo_data_out;

    logic fifo_master_start;
    logic fifo_master_ready;
    logic fifo_empty;

    assign fifo_data_in = { addr_in, data_in };

    i2c_fifo fifo (
        .clk(clk_in),
        .rst(reset_in),
        .din(fifo_data_in),
        .wr_en(start),

        .rd_en(fifo_master_start),
        .dout(fifo_data_out),
        .full(fifo_full),
        .empty(fifo_empty)
    );

    assign fifo_master_start = ~fifo_empty & fifo_master_ready;

    i2c master (
        .clk(clk_in),
        .reset(reset_in),
        .start(fifo_master_start),
        .addr(fifo_data_out[14:8]),
        .data(fifo_data_out[7:0]),
        .i2c_sda(i2c_sda_inout),
        .i2c_scl(i2c_scl_inout),
        .ready(fifo_master_ready)
    );



endmodule