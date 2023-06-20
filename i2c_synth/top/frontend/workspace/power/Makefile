# +XMENHDR----------------------------------------------------------------------
# Copyright (c) 2018 XMEN-UFCG. All rights reserved
# XMEN-UFCG Confidential Proprietary
#------------------------------------------------------------------------------
# FILE NAME            : Makefile
# AUTHOR               : Bruno Silva
# AUTHOR'S E-MAIL      : bruno.silva@embedded.ufcg.edu.br
# -----------------------------------------------------------------------------
# RELEASE HISTORY
# VERSION  DATE        AUTHOR              DESCRIPTION
# 0.1      2019-02-26  bruno.silva         Initial version
# 0.2      2019-03-01  bruno.silva         Revised
# 0.3      2019-03-21  bruno.silva         Revised -new dir.
# -----------------------------------------------------------------------------
# KEYWORDS: Netlist, power analysis
# -----------------------------------------------------------------------------
# PURPOSE: Power analysis (average and profile)
# -----------------------------------------------------------------------------
# REUSE ISSUES
#   Other: N/A
# -XMENHDR----------------------------------------------------------------------
block = xxx

average:
	@voltus -nowin -log ../../logs/power/pwr_ana_average_${block}.log -init ../../scripts/power/pwr_average.tcl
prof:
	@voltus -nowin -log ../../logs/power/pwr_ana_prof_${block}.log -init ../../scripts/power/pwr_prof.tcl
clean: 
	@rm -rf .cadence .ssv* *.gz ../../logs/power/* ../../reports/power/* *.txt *.db* .top.db .powerAnalysis.pinfo RCDB* voltus* *.cmd* *.log *.rpt
