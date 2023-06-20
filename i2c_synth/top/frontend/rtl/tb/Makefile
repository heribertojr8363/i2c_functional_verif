simulate:
	xrun -access +r -input shm.tcl "MODIFICAR"tb.sv ../src/"MODIFICAR".sv
create_tcl:
	@echo "database -open waves -shm" >> shm.tcl
	@echo "probe -create tb -depth all -all -memories -shm -database waves" >> shm.tcl
	@echo "run 18 ms -absolute" >> shm.tcl
	@echo "exit" >> shm.tcl
waves:
	simvision waves.shm
clean:
	rm -rf shm.tcl *.shm xcelium.d xrun.* .simvision
