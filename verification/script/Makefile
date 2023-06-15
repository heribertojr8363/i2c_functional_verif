#///////////////////////////////////////////////////////////////////////////////////////////////////
#//
#//        CLASS: Makefile
#//  DESCRIPTION: 
#//         BUGS: ---
#//       AUTHOR: Matheus Almeida, matheus.almeida@embedded.ufcg.edu.br
#// ORGANIZATION: XMEN - Laboratorio de Excelencia em Microeletronica do Nordeste 
#//      VERSION: 1.0
#//      CREATED: 08/14/2019 02:05:25 PM
#//     REVISION: ---
#///////////////////////////////////////////////////////////////////////////////////////////////////

SCRIPT_SRC = ../scripts
VSRC = ../src
VTB = ../tb
VSCRIPT = ../script
DUT = ../../dut

IF = $(VSRC)/i2c_interface.svh
#PKGS_TYPES = $(VSRC)/axi4_lite_vip_defs.svh
PKGS_VIP = $(VSRC)/i2c_pkg.svh
PKGS = $(VTB)/top_pkg.sv
#$(PKGS_TYPES) $(PKGS_VIP) $(PKGS)

MODE = ALL
SEED = 125
COVER = 100
TRANSA = 5000

run:
	@xrun -64bit -uvm +incdir+$(VTB) +incdir+$(VSRC) +incdir+$(DUT) +incdir+$(VSCRIPT) $(PKGS_VIP) $(PKGS) $(IF) $(VTB)/top.sv \
    +UVM_TESTNAME=my_test -covtest my_test-$(SEED) -define $(MODE) -svseed $(SEED) -ALLOWREDEFINITION +nccoverage+all -cov_cgsample -coverage u

clean:
	@rm -rf INCA_libs waves.shm rtlsim/* *.history *.log rtlsim/* *.key mdv.log imc.log imc.key ncvlog_*.err *.trn *.dsn .simvision/ xcelium.d simv.daidir *.so *.o *.err cov_work simvision* *.out *.txt

rebuild: clean sim

gui:
	@xrun -64bit -uvm +incdir+$(VTB) +incdir+$(VSRC) +incdir+$(VSCRIPT) $(PKGS_TYPES) $(PKGS_VIP) $(PKGS) $(IF) $(VTB)/top.sv \
    +UVM_TESTNAME=my_test -covtest my_test-$(SEED) -define $(MODE) -svseed $(SEED) -gui -ALLOWREDEFINITION -access +rwc

cover:
	imc &


