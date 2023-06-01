interface i2c_interface (input clk, input rst);
	logic scl;
	logic sda;

  // modport mst(output scl, inout sda, input clk, input rst);
  // modport mst(input  scl, inout sda, input clk, input rst);
endinterface
