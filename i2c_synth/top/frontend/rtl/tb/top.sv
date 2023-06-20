`include "i2c_master.sv"

module top;

    import uvm_pkg::*;
    import i2c_pkg::*;
    import top_pkg::*;

    bit clk;
    bit reset;

    i2c_interface i2c_if(.clk(clk), .reset(reset));
    i2c_master mst(i2c_if);

     initial begin
      clk = 1;
      reset = 0;
      #10ns reset = 1;
      #10ns reset = 0;
    end

    always #10ns clk = !clk;

    initial begin
        uvm_config_db#(virtual i2c_interface)::set(uvm_root::get(), "*", "vif", i2c_if);
        run_test("my_test");
    end
endmodule
