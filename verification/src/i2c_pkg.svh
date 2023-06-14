`ifndef I2C_PKG
`define I2C_PKG

`timescale 1ns/1ps

package i2c_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "../src/i2c_sequence_item.svh"
    `include "../src/i2c_sequence.svh"
    `include "../src/i2c_sequencer.svh"
    `include "../src/i2c_driver.svh"
    `include "../src/i2c_monitor.svh"
    `include "../src/i2c_agent.svh"

endpackage

`endif//I2C_PKG
