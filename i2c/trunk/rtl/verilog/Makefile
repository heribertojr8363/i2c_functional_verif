simulate:
	xrun -access +r -input shm.tcl i2c_master_top.v i2c_master_byte_ctrl.v i2c_master_bit_ctrl.v
create_tcl:
	@echo "database -open waves -shm" >> shm.tcl
	@echo "probe -create tb -depth all -all -memories -shm -database waves" >> shm.tcl
	@echo "run 18 ms -absolute" >> shm.tcl
	@echo "exit" >> shm.tcl
waves:
	simvision waves.shm
clean:
	rm -rf shm.tcl *.shm xcelium.d xrun.* .simvision
