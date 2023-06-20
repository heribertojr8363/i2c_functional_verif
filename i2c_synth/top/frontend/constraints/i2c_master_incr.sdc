# ####################################################################

#  Created by Genus(TM) Synthesis Solution 19.15-s090_1 on Sun Jun 18 14:54:20 -03 2023

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design i2c_master

create_clock -name "clk" -period 20.0 -waveform {0.0 10.0} [get_ports clk]
set_load -pin_load 0.0 [get_ports i2c_scl]
set_load -pin_load 0.0 [get_ports i2c_sda]
group_path -weight 1.000000 -name C2C -from [list \
  [get_cells count_reg_2]  \
  [get_cells count_reg_1]  \
  [get_cells next_reg_1]  \
  [get_cells next_reg_0]  \
  [get_cells next_reg_2]  \
  [get_cells next_reg_3]  \
  [get_cells current_reg_2]  \
  [get_cells current_reg_0]  \
  [get_cells count_reg_0]  \
  [get_cells current_reg_3]  \
  [get_cells current_reg_1] ] -to [list \
  [get_cells RC_CG_HIER_INST0/RC_CGIC_INST]  \
  [get_cells RC_CG_HIER_INST1/RC_CGIC_INST]  \
  [get_cells count_reg_2]  \
  [get_cells count_reg_1]  \
  [get_cells next_reg_1]  \
  [get_cells next_reg_0]  \
  [get_cells next_reg_2]  \
  [get_cells next_reg_3]  \
  [get_cells current_reg_2]  \
  [get_cells current_reg_0]  \
  [get_cells count_reg_0]  \
  [get_cells current_reg_3]  \
  [get_cells current_reg_1] ]
group_path -weight 1.000000 -name C2O -from [list \
  [get_cells count_reg_2]  \
  [get_cells count_reg_1]  \
  [get_cells next_reg_1]  \
  [get_cells next_reg_0]  \
  [get_cells next_reg_2]  \
  [get_cells next_reg_3]  \
  [get_cells current_reg_2]  \
  [get_cells current_reg_0]  \
  [get_cells count_reg_0]  \
  [get_cells current_reg_3]  \
  [get_cells current_reg_1] ] -to [list \
  [get_ports i2c_scl]  \
  [get_ports i2c_sda] ]
group_path -weight 1.000000 -name I2C -from [list \
  [get_ports clk]  \
  [get_ports reset]  \
  [get_ports start]  \
  [get_ports stop]  \
  [get_ports rw]  \
  [get_ports {addr[6]}]  \
  [get_ports {addr[5]}]  \
  [get_ports {addr[4]}]  \
  [get_ports {addr[3]}]  \
  [get_ports {addr[2]}]  \
  [get_ports {addr[1]}]  \
  [get_ports {addr[0]}]  \
  [get_ports {w_data[7]}]  \
  [get_ports {w_data[6]}]  \
  [get_ports {w_data[5]}]  \
  [get_ports {w_data[4]}]  \
  [get_ports {w_data[3]}]  \
  [get_ports {w_data[2]}]  \
  [get_ports {w_data[1]}]  \
  [get_ports {w_data[0]}]  \
  [get_ports i2c_sda] ] -to [list \
  [get_cells RC_CG_HIER_INST0/RC_CGIC_INST]  \
  [get_cells RC_CG_HIER_INST1/RC_CGIC_INST]  \
  [get_cells count_reg_2]  \
  [get_cells count_reg_1]  \
  [get_cells next_reg_1]  \
  [get_cells next_reg_0]  \
  [get_cells next_reg_2]  \
  [get_cells next_reg_3]  \
  [get_cells current_reg_2]  \
  [get_cells current_reg_0]  \
  [get_cells count_reg_0]  \
  [get_cells current_reg_3]  \
  [get_cells current_reg_1] ]
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports clk]  \
  [get_ports reset]  \
  [get_ports start]  \
  [get_ports stop]  \
  [get_ports rw]  \
  [get_ports {addr[6]}]  \
  [get_ports {addr[5]}]  \
  [get_ports {addr[4]}]  \
  [get_ports {addr[3]}]  \
  [get_ports {addr[2]}]  \
  [get_ports {addr[1]}]  \
  [get_ports {addr[0]}]  \
  [get_ports {w_data[7]}]  \
  [get_ports {w_data[6]}]  \
  [get_ports {w_data[5]}]  \
  [get_ports {w_data[4]}]  \
  [get_ports {w_data[3]}]  \
  [get_ports {w_data[2]}]  \
  [get_ports {w_data[1]}]  \
  [get_ports {w_data[0]}]  \
  [get_ports i2c_sda] ] -to [list \
  [get_ports i2c_scl]  \
  [get_ports i2c_sda] ]
group_path -weight 1.000000 -name cg_enable_group_clk -through [list \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST1/enable]  \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST1/enable]  \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST1/enable] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports reset]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports start]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports stop]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports rw]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {addr[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {addr[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {addr[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {addr[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {addr[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {addr[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {addr[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {w_data[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {w_data[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {w_data[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {w_data[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {w_data[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {w_data[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {w_data[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports {w_data[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports i2c_sda]
set_output_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports i2c_scl]
set_output_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports i2c_sda]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LGCNHDX0]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LGCNHDX1]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LGCNHDX2]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LGCNHDX4]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LGCPHDX0]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LGCPHDX1]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LGCPHDX2]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LGCPHDX4]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSGCNHDX0]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSGCNHDX1]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSGCNHDX2]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSGCNHDX4]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSGCPHDX0]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSGCPHDX1]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSGCPHDX2]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSGCPHDX4]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSOGCNHDX0]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSOGCNHDX1]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSOGCNHDX2]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSOGCNHDX4]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSOGCPHDX0]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSOGCPHDX1]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSOGCPHDX2]
set_dont_use false [get_lib_cells D_CELLS_HD_LPMOS_slow_1_62V_125C/LSOGCPHDX4]
