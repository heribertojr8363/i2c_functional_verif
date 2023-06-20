# +XMENHDR----------------------------------------------------------------------
# Copyright (c) 2018 XMEN-UFCG. All rights reserved
# XMEN-UFCG Confidential Proprietary
#------------------------------------------------------------------------------
# FILE NAME            : pwr_prof.tcl
# AUTHOR               : Bruno Silva
# AUTHOR'S E-MAIL      : bruno.silva@embedded.ufcg.edu.br
# -----------------------------------------------------------------------------
# RELEASE HISTORY
# VERSION  DATE        AUTHOR              DESCRIPTION
# 0.1      2019-02-26  bruno.silva         Initial version
# 0.2      2019-03-01  bruno.silva         Revised
# 0.3      2019-03-21  bruno.silva         Revised - new dir.
# 0.4      2029-01-29  bruno.silva         Revised - Added the library of 1.2V 
# -----------------------------------------------------------------------------
# KEYWORDS: Netlist, power analysis
# -----------------------------------------------------------------------------
# PURPOSE: Power analysis (average and profile)
# -----------------------------------------------------------------------------
# REUSE ISSUES
#   Other: N/A
# -XMENHDR----------------------------------------------------------------------

set DESIGN        xxx
set POWER_MODE   "profile"
set OP_COND      "typ"
set PERIOD        20
set PROCESS_NODE  180
set USE_DCELL_1V2 0

if { $USE_DCELL_1V2 == 1 } {
     set LIB_TIMING  /mnt/hdd1tera/xfab_xh018/xh018/diglibs/D_CELLS_HD/v3_0/liberty_LPMOS/v3_0_1/PVT_1_20V_range
} else {
     set LIB_TIMING  /mnt/hdd1tera/xfab_xh018/xh018/diglibs/D_CELLS_HD/v3_0/liberty_LPMOS/v3_0_1/PVT_1_80V_range
}
set LIB_TECHLEF /mnt/hdd1tera/xfab_xh018/xh018/cadence/v7_0/techLEF/v7_0_3/xh018_xx43_HD_MET4_METMID_METTHK.lef 
set LIB_LEF     /mnt/hdd1tera/xfab_xh018/xh018/diglibs/D_CELLS_HD/v3_0/LEF/v3_0_0/xh018_D_CELLS_HD.lef
set SYNDIR      ../../
set SIMDIR      ../../switching
set RPTDIR      ../../reports/power

set_design_mode -process $PROCESS_NODE

################################### Load the libraries and set the operating conditions #####################################

#----------------------------------- Typical case --------------------------------------------------------
if { $OP_COND == "typ"} {
     if { $USE_DCELL_1V2 == 1 } {
          read_lib $LIB_TIMING/D_CELLS_HD_LPMOS_typ_1_20V_25C.lib
     } else {
          read_lib $LIB_TIMING/D_CELLS_HD_LPMOS_typ_1_80V_25C.lib
     }
}

#----------------------------------- Fast case --------------------------------------------------------
if { $OP_COND == "fast"} {
     if { $USE_DCELL_1V2 == 1 } {
          read_lib -min $LIB_TIMING/D_CELLS_HD_LPMOS_fast_1_32V_m40C.lib
     } else {
          read_lib -min $LIB_TIMING/D_CELLS_HD_LPMOS_fast_1_98V_m40C.lib
     }
}

#----------------------------------- Slow case --------------------------------------------------------
if { $OP_COND == "slow"} {
     if { $USE_DCELL_1V2 == 1 } {
          read_lib -max $LIB_TIMING/D_CELLS_HD_LPMOS_slow_1_08V_125C.lib
     } else {
          read_lib -min $LIB_TIMING/D_CELLS_HD_LPMOS_slow_1_62V_125C.lib
     }
}

############################ Load the netlist and the other need files to perform the analysis ###########################

read_lib -lef $LIB_TECHLEF $LIB_LEF
read_verilog $SYNDIR/structural/${DESIGN}.v
set_top_module $DESIGN
read_sdc $SYNDIR/constraints/${DESIGN}_incr.sdc
read_spef $SYNDIR/parasitics/${DESIGN}.spef

############################################### Perform the power activity analysis ##############################################

if { $POWER_MODE == "profile"} {
   set_power_analysis_mode -reset
   set_switching_activity -reset
   set_power -reset
   set_switching_activity -reset
   set_powerup_analysis -reset
   set_dynamic_power_simulation -reset
   read_activity_file -reset

   set_power_analysis_mode -method dynamic_vectorbased -disable_static true -create_binary_db false -write_static_currents false
   set_default_switching_activity -input_activity 0.2 -period $PERIOD -duty 0.5

   read_activity_file -format VCD -report_missing_nets true -vcd_scope ${DESIGN}_tb/${DESIGN} $SIMDIR/${DESIGN}_synth.vcd
   propagate_activity

   report_vector_profile -average_power -align_with_signal_edge clk_i@rising -write_profiling_db true -step $PERIOD -outfile $RPTDIR/${DESIGN}_pwr_analysis_${POWER_MODE}_${OP_COND}.rpt -average_instance_report true
}

exit
