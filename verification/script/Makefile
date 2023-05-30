VIP_SRC = ../src
TB_SRC = ../tb

IFS = ../src/i2c_vip_interface.sv

PKGS = ../src/i2c_vip_pkg.svh \
	   ../tb/top_pkg.sv \

sim:
	xrun -64bit -uvm +incdir+$(VIP_SRC)+$(TB_SRC) $(PKGS) $(IFS)  ../tb/top.sv

gui:
	xrun -64bit -uvm +incdir+$(VIP_SRC)+$(TB_SRC) $(PKGS) $(IFS)  ../tb/top.sv -gui

clean:
	@rm -rf INCA_libs waves.shm *.history *.log *.key imc.key *.trn *.dsn .simvision/ xcelium.d simv.daidir *.so *.o *.err
