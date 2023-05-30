module top;

    import uvm_pkg::*;
    import i2c_vip_pkg::*;
    import top_pkg::*;

    logic clk;

    i2c_vip_interface i2c_if(.clk(clk));

    always #1 clk = !clk;

    initial begin
        clk = 0;

        uvm_config_db#(virtual i2c_vip_interface)::set(uvm_root::get(), "*", "i2c_vip_vif", i2c_if);

        run_test("my_test");
    end
endmodule
