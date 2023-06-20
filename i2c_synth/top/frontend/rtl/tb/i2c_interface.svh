interface i2c_interface (input bit clk, input bit reset);

  // Inputs
  logic start;
  logic stop;
  logic rw;
  logic [6:0] addr;
  logic [7:0] w_data;

  // Outputs
  logic i2c_scl;
  logic i2c_sda;


  modport master(input clk, reset, start, stop, rw, addr, w_data,
                 output i2c_scl, inout i2c_sda);
  // modport mst(input  scl, inout sda, input clk, input rst);
endinterface
