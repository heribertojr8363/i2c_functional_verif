`ifndef I2C_VIP_PKG
`define I2C_VIP_PKG

`timescale 1ns/1ps

package i2c_vip_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "i2c_vip_sequence_item.svh"
    `include "i2c_vip_agent_config.svh"
    `include "i2c_vip_driver.svh"
    // `include "i2c_vip_monitor.svh"
    `include "i2c_vip_agent.svh"

endpackage

`endif//I2C_VIP_PKG
