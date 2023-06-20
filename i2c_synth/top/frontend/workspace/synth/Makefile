# +XMENHDR----------------------------------------------------------------------
# Copyright (c) 2018 XMEN-UFCG. All rights reserved
# XMEN-UFCG Confidential Proprietary
#------------------------------------------------------------------------------
# FILE NAME            : makefile
# AUTHOR               : Bruno Silva
# AUTHOR'S E-MAIL      : bruno.silva@embedded.ufcg.edu.br
# -----------------------------------------------------------------------------
# RELEASE HISTORY
# VERSION  DATE        AUTHOR              DESCRIPTION
# 0.1      2019-02-26  bruno.silva         Initial version
# 0.2      2019-03-01  bruno.silva         Revised
# 0.3      2019-03-21  bruno.silva         Revised -new dir.
# 0.4      2019-05-20  bruno.silva         Revised -new dir.
# -----------------------------------------------------------------------------
# KEYWORDS: logic synthesis, STA and power analysis
# -----------------------------------------------------------------------------
# PURPOSE: Logic synthesis
# -----------------------------------------------------------------------------
# REUSE ISSUES
#   Other: N/A
# -XMENHDR----------------------------------------------------------------------
block = xxx
synth = ../../scripts/synth/synth.tcl
        
synth:
	@genus -f $(synth) -log ../../logs/synth/synth_${block}.log
debug:
	@vim ../../logs/synth/synth_${block}.log
clean: 
	@rm -rf fv/ genus.* *.rpt ../../logs/synth/* ../../reports/area/* ../../reports/timing/* ../../reports/synth/* ../../structural/* ../../constraints/*.sdc ../../timing/*.sdf ../../parasitics/*.spef ../../../dft/patterns/*
