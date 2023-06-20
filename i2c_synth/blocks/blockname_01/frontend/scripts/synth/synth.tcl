## +XMENHDR----------------------------------------------------------------------
## Copyright (c) 2018 XMEN-UFCG. All rights reserved
## XMEN-UFCG Confidential Proprietary
##------------------------------------------------------------------------------
## FILE NAME            : synth.tcl
## AUTHOR               : Bruno Silva
## AUTHOR'S E-MAIL      : bruno.silva@embedded.ufcg.edu.br
## -----------------------------------------------------------------------------
## RELEASE HISTORY
## VERSION  DATE        AUTHOR              DESCRIPTION
## 0.1      2019-02-27  bruno.silva         Initial version
## 0.2      2019-02-28  bruno.silva         Revised - added the DFT insertion/setup
## 0.3      2019-03-01  bruno.silva         Revised
## 0.3      2019-03-21  bruno.silva         Revised -new dir.
## 0.4      2020-01-24  bruno.silva         Revised -clock gating setup
## 1.0      2020-01-29  bruno.silva         Revised -clock gating/lib 1.2V
## -----------------------------------------------------------------------------
## KEYWORDS: Logic synthesis. STA and power analysis
## -----------------------------------------------------------------------------
## PURPOSE: Logic synthesis
## -----------------------------------------------------------------------------
## REUSE ISSUES
##   Other: N/A
## -XMENHDR----------------------------------------------------------------------

set start_time [clock seconds] 

#######################################################################################################
## Preset global variables and attributes
#######################################################################################################

set DESIGN xxx
set GEN_EFF high
set MAP_OPT_EFF   high
set OUTPUTSDIR    ../../
set REPORTSDIR    ../../reports/synth
set LOGSDIR       ../../logs/synth
set SIMDIR        ../../switching
set CLK_PERIOD    20
set DFT           0
set ICG           1
set USE_DCELL_1V2 0

set_db / .init_hdl_search_path {../../rtl/src} 
set rtl_list_file [open "../../rtl/src/rtl_list.txt" r]
set rtl_list [read $rtl_list_file]
close $rtl_list_file

set_db / .information_level 5
set_db / .hdl_error_on_latch true
set_db / .hdl_report_case_info true
set_db / .hdl_array_naming_style %s_%d
set_db / .hdl_create_label_for_unlabeled_generate false
set_db / .auto_ungroup none
set_db / .tns_opto true

#######################################################################################################
## Library setup
#######################################################################################################

set TECHLIBBASE "/mnt/hdd1tera/xfab_xh018/xh018"

if { $USE_DCELL_1V2 == 1 } {
set TECHLIB_S_PATH "$TECHLIBBASE/diglibs/D_CELLS_HD/v3_0/liberty_LPMOS/v3_0_1/PVT_1_20V_range \
                    $TECHLIBBASE/diglibs/D_CELLS_HD/v3_0/LEF/v3_0_0 \
                    $TECHLIBBASE/cadence/v7_0/techLEF/v7_0_3 \
                    $TECHLIBBASE/cadence/v7_0/capTbl/v7_0_2"
} else {
set TECHLIB_S_PATH "$TECHLIBBASE/diglibs/D_CELLS_HD/v3_0/liberty_LPMOS/v3_0_1/PVT_1_80V_range \
                    $TECHLIBBASE/diglibs/D_CELLS_HD/v3_0/LEF/v3_0_0 \
                    $TECHLIBBASE/cadence/v7_0/techLEF/v7_0_3 \
                    $TECHLIBBASE/cadence/v7_0/capTbl/v7_0_2"
}

set LEF_LIST "{xh018_xx43_HD_MET4_METMID_METTHK.lef \
	       xh018_D_CELLS_HD.lef}"

if { $USE_DCELL_1V2 == 1 } {
     set TIME_LIST "D_CELLS_HD_LPMOS_slow_1_08V_125C.lib" 
} else {
     set TIME_LIST "D_CELLS_HD_LPMOS_slow_1_62V_125C.lib"
}

set CAPTBL_LIST "xh018_xx43_MET4_METMID_METTHK_max.capTbl"

set_db / .init_lib_search_path $TECHLIB_S_PATH
set_db / .library $TIME_LIST
set_db / .lef_library $LEF_LIST
set_db / .cap_table_file $CAPTBL_LIST

#######################################################################################################
## Load Design
#######################################################################################################
read_hdl -sv $rtl_list

if { $ICG == 1 } {
     set_db / .lp_insert_clock_gating true
}

elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"

edit_netlist uniquify $DESIGN -verbose

time_info Elaboration

check_design -unresolved

#######################################################################################################
## Constraints Setup
#######################################################################################################
read_tcf -tcf_instance $DESIGN $SIMDIR/${DESIGN}_rtl.tcf

dc::create_clock [dc::get_ports {clk_i}] -name "clk" -period $CLK_PERIOD
dc::set_input_delay 0  -clock clk  [all_inputs]
dc::set_output_delay 0  -clock clk  [all_outputs]
dc::set_load 0 [all_outputs]
dc::set_clock_uncertainty -setup [expr ($CLK_PERIOD/100)] [dc::get_clocks {clk}]
dc::set_clock_uncertainty -hold [expr ($CLK_PERIOD/100)] [dc::get_clocks {clk}]
dc::set_clock_latency [expr ($CLK_PERIOD/100)] -source -rise [dc::get_clocks {clk}]
dc::set_clock_latency [expr ($CLK_PERIOD/100)] -source -fall [dc::get_clocks {clk}]

check_design -unresolved

report_clocks
report_clocks -generated

puts "The number of exceptions is [llength [vfind "design:$DESIGN" -exception *]]"

if {![file exists ${LOGSDIR}]} {
 file mkdir ${LOGSDIR}
 puts "Creating directory ${LOGSDIR}"
}

if {![file exists ${OUTPUTSDIR}]} {
 file mkdir ${OUTPUTSDIR}
 puts "Creating directory ${OUTPUTSDIR}"
}

if {![file exists ${REPORTSDIR}]} {
 file mkdir ${REPORTSDIR}
 puts "Creating directory ${REPORTSDIR}"
}

report_timing -lint

#######################################################################################################
## Clock gating Setup
#######################################################################################################
foreach icg_cell [get_db lib_cells -if {.is_integrated_clock_gating==true}] { puts "[set_db $icg_cell .avoid false]" }
set_db / .lp_power_analysis_effort high
set_db / .lp_power_unit mW
#get_db base_cells -if {.clock_gating_integrated_cell==latch_posedge} -foreach { puts   $object }
#set_db [get_db designs $DESIGN* ] .lp_clock_gating_cell [get_db lib_cells *LGCPHDX0*]
#set_db / .lp_insert_discrete_clock_gating_logic true

#######################################################################################################
## Optimize Netlist
#######################################################################################################
set_db / .dp_perform_sharing_operations true
set_db / .dp_area_mode true
set_db / .dp_postmap_downsize true
set_db / .optimize_merge_flops true
set_db / .lp_insert_operand_isolation false
set_db / .optimize_merge_latches false 
set_db / .remove_assigns true 
set_db / .use_tiehilo_for_const duplicate
set_db / .hdl_preserve_unused_registers true
set_db / .hdl_latch_keep_feedback true

#######################################################################################################
## Define cost groups (clock-clock, clock-output, input-clock, input-output)
#######################################################################################################

if {[llength [all::all_seqs]] > 0} { 
  define_cost_group -name I2C -design $DESIGN
  define_cost_group -name C2O -design $DESIGN
  define_cost_group -name C2C -design $DESIGN
  path_group -from [all::all_seqs] -to [all::all_seqs] -group C2C -name C2C
  path_group -from [all::all_seqs] -to [all::all_outs] -group C2O -name C2O
  path_group -from [all::all_inps]  -to [all::all_seqs] -group I2C -name I2C
}

define_cost_group -name I2O -design $DESIGN
path_group -from [all::all_inps]  -to [all::all_outs] -group I2O -name I2O

#######################################################################################################
## DFT setup
#######################################################################################################

if { $DFT == 1} {
    puts "DFT setup ..." 
    ## ( Step 1) set the scan style to muxed_scan (use of scan FFs)
    set_db / .dft_scan_style muxed_scan
    ## ( Step 2) set DFT specific attributes
    set_db / .dft_prefix DFT_  
    set_db / .dft_identify_top_level_test_clocks false
    set_db / .dft_identify_test_signals false
    set_db / .dft_identify_internal_test_clocks false
    set_db / .use_scan_seqs_for_non_dft false
    # These are synthesis specific attributes associated with DFT insertion 
    set_db "design:$DESIGN" .lp_clock_gating_control_point precontrol
    set_db "design:$DESIGN" .dft_scan_map_mode tdrc_pass
    set_db "design:$DESIGN" .dft_connect_shift_enable_during_mapping tie_off
    set_db "design:$DESIGN" .dft_connect_scan_data_pins_during_mapping floating
    set_db "design:$DESIGN" .dft_scan_output_preference non_inverted
    set_db "design:$DESIGN" .dft_lockup_element_type preferred_level_sensitive
    ## ( Step 3) define test signals
    define_dft test_clock -name clk_i -period [expr ($CLK_PERIOD*1000)] clk_i
    define_dft shift_enable -name dft_shift_en -active high -create_port dft_shift_en
    define_dft test_mode -name dft_tm_i -active high -create_port -no_ideal dft_tm_i   
    define_dft scan_chain -name TESTSCAN -sdi dft_sdi -sdo dft_sdo -create_ports -shift_enable dft_shift_en -non_shared_output 
   
    ## Fix the DFT Violations
    set numDFTviolations [check_dft_rules]
    if {$numDFTviolations > "0"} {
	report dft_violations > ${REPORTSDIR}/${DESIGN}_DFTviols.rpt
	fix_dft_violations -clock -test_control dft_shift_en -test_clock_pin clk_i
	fix_dft_violations -async_set -async_reset -test_control dft_shift_en
	check_dft_rules
      }
      
}

#######################################################################################################
## Synthesizing to generic 
#######################################################################################################
set_db / .syn_generic_effort $GEN_EFF
syn_generic

puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC

######################################################################################################
## Synthesizing to gates
#######################################################################################################
set_db / .syn_map_effort $MAP_OPT_EFF
syn_map

puts "Runtime & Memory after 'syn_map'"
time_info MAPPED

#######################################################################################################
## Optimize Netlist
#######################################################################################################
set_db / .syn_opt_effort $MAP_OPT_EFF
syn_opt

puts "Runtime & Memory after 'syn_opt'"
time_info OPT

if { $DFT == 1} {
    puts "DFT create ..."  
    set_db "design:$DESIGN" .lp_clock_gating_test_signal dft_shift_en
    add_clock_gates_test_connection
    check_dft_rules

    ## Fix the DFT Violations
    set numDFTviolations [check_dft_rules]
    if {$numDFTviolations > "0"} {
	report dft_violations > ${REPORTSDIR}/${DESIGN}_DFTviols.rpt
	fix_dft_violations -xsource -test_control dft_tm_i -test_clock_pin clk_i
	fix_dft_violations -clock -test_control dft_tm_i -test_clock_pin clk_i
	fix_dft_violations -async_set -async_reset -test_control dft_tm_i
	check_dft_rules
      }
          
    replace_scan
    identify_shift_register_scan_segments -min_length 8 -max_length 2000
    replace_scan -to_non_scan
    check_dft_rules     
}

#######################################################################################################
## Optimize Netlist
#######################################################################################################
if { $DFT == 1} {
    set_db / .syn_opt_effort $MAP_OPT_EFF
    syn_opt -incremental

    puts "Runtime & Memory after 'syn_opt'"
    time_info INCREMENTAL_POST_SCAN_CHAINS
}

######################################################################################################
## write backend file set (verilog, SDC, config, etc.)
######################################################################################################

report power -verbose                           > ${REPORTSDIR}/report_power_${DESIGN}.txt
report timing -lint                             > ${REPORTSDIR}/report_time_${DESIGN}.txt
report timing                                   > ${REPORTSDIR}/report_slack_${DESIGN}.txt
report area                                     > ${REPORTSDIR}/report_area_${DESIGN}.txt
report gates                                    > ${REPORTSDIR}/report_gates_${DESIGN}.txt
report qor                                      > ${REPORTSDIR}/report_qor_${DESIGN}.txt
report messages                                 > ${REPORTSDIR}/report_messages_${DESIGN}.txt
report summary                                  > ${REPORTSDIR}/report_summary_${DESIGN}.txt
if { $ICG == 1 } {
     report clock_gating -detail                > ${REPORTSDIR}/report_clockgating_detail_${DESIGN}.txt
     report clock_gating -gated_ff              > ${REPORTSDIR}/report_clockgating_gated_${DESIGN}.txt
     report clock_gating -ungated_ff            > ${REPORTSDIR}/report_clockgating_ungated_${DESIGN}.txt
}

if { $DFT == 1} {
    check_dft_rules -advanced                   > ${REPORTSDIR}/check_dft_rules_${DESIGN}.txt
    report dft_registers                        > ${REPORTSDIR}/report_dft_registers_${DESIGN}.txt
    report dft_violations                       > ${REPORTSDIR}/report_dft_violations_${DESIGN}.txt
    report dft_setup                            > ${REPORTSDIR}/report_dft_setup_${DESIGN}.rpt 
}

# remove_cdn_loop_breaker must be before write_hdl and after sdf write
remove_cdn_loop_breaker

# to limit the numbers of characters applied to the module / instance / port / net name
update_names -max_length 50 -module

write_hdl                                       > ${OUTPUTSDIR}/structural/${DESIGN}.v
write_sdc                                       > ${OUTPUTSDIR}/constraints/${DESIGN}_incr.sdc
write_sdf -edges check_edge                     > ${OUTPUTSDIR}/timing/${DESIGN}.sdf
write_parasitics                                > ${OUTPUTSDIR}/parasitics/${DESIGN}.spef

if { $DFT == 1} {
    connect_scan_chain
    write_scandef                               > ${OUTPUTSDIR}/../dft/patterns/${DESIGN}_scanDEF
    write_dft_abstract_model                    > ${OUTPUTSDIR}/../dft/patterns/${DESIGN}-scanAbstract
    write_hdl -abstract                         > ${OUTPUTSDIR}/../dft/patterns/${DESIGN}-logicAbstract
    write_script -analyze_all_scan_chains       > ${OUTPUTSDIR}/../dft/patterns/${DESIGN}-writeScript-analyzeAllScanChains
    write_dft_atpg -library $TECHLIBBASE/diglibs/D_CELLS_HD/v3_0/verilog/v3_0_0/D_CELLS_HD.v -compression -directory ${OUTPUTSDIR}/../dft/patterns
    check_atpg_rules -library $TECHLIBBASE/diglibs/D_CELLS_HD/v3_0/verilog/v3_0_0/D_CELLS_HD.v -compression -directory ${OUTPUTSDIR}/../dft/patterns
}

puts "Final Runtime & Memory."
time_info FINAL

puts "============================"
puts "Synthesis Finished ........."
puts "============================"

set stop_time [clock seconds]
    
puts "<XMEN> =============================================="
puts "<XMEN>         Elapsed runtime : [clock format [expr $stop_time - $start_time] -format %H:%M:%S -gmt true]"
puts "<XMEN> =============================================="

quit
