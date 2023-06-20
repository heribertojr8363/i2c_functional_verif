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
# -----------------------------------------------------------------------------
# KEYWORDS: rtl level simulation, power analysis (setup)
# -----------------------------------------------------------------------------
# PURPOSE: rtl level simulation
# -----------------------------------------------------------------------------
# REUSE ISSUES
#   Other: N/A
# -XMENHDR----------------------------------------------------------------------
block = xxx

run:
	@irun -f ../../scripts/rtlsim/setup
debug:
	@vim ../../logs/rtlsim/rtlsim_${block}.log
coverage:
	@iccr -gui &
waves:
	@simvision waves.shm &
clean:
	@rm -rf ../../logs/rtlsim/* .simvision/ cov_work/ INCA_libs/ waves.shm/ ../../switching/*_rtl.vcd ../../switching/*_rtl.tcf
