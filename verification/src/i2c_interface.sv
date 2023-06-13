interface i2c_interface #(ADDR_WIDTH=7,DATA_WIDTH=8)(input logic clk, input logic reset);

  // Inputs
  logic start;
  logic stop;
  logic rw;
  logic [ADDR_WIDTH - 1:0] addr;
  logic [DATA_WIDTH - 1:0] w_data;

  // Outputs
  logic i2c_scl;
  logic i2c_sda;


  modport mst(input clk, reset, start, stop, rw, addr, w_data,
              output i2c_scl, inout i2c_sda);
  // modport mst(input  scl, inout sda, input clk, input rst);
endinterface
