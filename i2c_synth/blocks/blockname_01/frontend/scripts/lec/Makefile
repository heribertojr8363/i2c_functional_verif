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
# KEYWORDS: LEC, synthesis, BBOX and DFT
# -----------------------------------------------------------------------------
# PURPOSE: Logic equivalence checking (RTL vs GATE)
# -----------------------------------------------------------------------------
# REUSE ISSUES
#   Other: N/A
# -XMENHDR----------------------------------------------------------------------
block = xxx

check:
	@lec -xl -DOfile ../../scripts/lec/dofile -nogui
debug:
	@lec -xl -DOfile ../../scripts/lec/dofile_debug -nogui
log:
	@vim ../../logs/lec/lec_${block}.log
clean: 
	@rm -rf ../../logs/lec/*.log*
