module top;

    import uvm_pkg::*;
    import i2c_pkg::*;
    import top_pkg::*;

    logic clk;
    logic reset;

     initial begin
      clk = 1;
      reset = 0;
      #20 reset = 1;
      #20 reset = 0;
    end

    i2c_interface i2c_if(.clk(clk), .reset(reset));

    always #10 clk = !clk;

    initial begin
        uvm_config_db#(virtual i2c_interface)::set(uvm_root::get(), "*", "vif", i2c_if);
        run_test("my_test");
    end
endmodule
