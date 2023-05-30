`ifndef I2C_VIP_AGENT_CONFIG
`define I2C_VIP_AGENT_CONFIG

class i2c_vip_agent_config extends uvm_object;
    `uvm_object_utils(i2c_vip_agent_config)

    uvm_active_passive_enum is_active = UVM_ACTIVE;
    int initial_delay_clock;
    int start_condition_post_delay;
    int clk_divider;
    int byte_number;

    function new(string name = "i2c_vip_agent_config");
        super.new(name);
        set_default();
    endfunction

    function void set_default();
        is_active = UVM_ACTIVE;
        initial_delay_clock = 10;
        start_condition_post_delay = 10;
        clk_divider = 10;
        byte_number = 1;
    endfunction

endclass

`endif//I2C_VIP_AGENT_CONFIG
