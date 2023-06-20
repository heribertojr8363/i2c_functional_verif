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
# 0.2      2019-03-21  bruno.silva         Revised -new dir.
# -----------------------------------------------------------------------------
# KEYWORDS: gate level simulation, STA, power analysis
# -----------------------------------------------------------------------------
# PURPOSE: gate level simulation
# -----------------------------------------------------------------------------
# REUSE ISSUES
#   Other: N/A
# -XMENHDR----------------------------------------------------------------------
block = xxx

run:
	@irun -f ../../scripts/gatesim/setup
debug:
	@vim ../../logs/gatesim/gatesim_${block}.log
waves:
	@simvision waves.shm &
clean:
	@rm -rf ../../logs/gatesim/* .simvision/ INCA_libs/ waves.shm/ ../../switching/*_synth.vcd ../../switching/*_synth.tcf *.log *.sdf*
