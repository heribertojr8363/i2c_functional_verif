# Caminho para os diretórios dos arquivos
I2C_DIR = ..
BENCH_DIR = $(I2C_DIR)/tb

# Flags para o Xcelium
XCELIUM_FLAGS = -access rwc \
	+incdir+$(BENCH_DIR) \
	+incdir+$(I2C_DIR)/src\
	-input shm.tcl \
        -default_port_array_wire

# Arquivos fonte
RTL_FILES = $(I2C_DIR)/src/i2c_master.sv

BENCH_FILES = $(BENCH_DIR)/i2c_tb.sv

# Comando para executar o Xcelium
XCELIUM_CMD = xrun -sv $(XCELIUM_FLAGS)

all:
	$(XCELIUM_CMD) $(RTL_FILES) $(BENCH_FILES)

waves:
	simvision waves.shm

create_tcl:
	@echo "database -open waves -shm" >> shm.tcl
	@echo "probe -create tb -depth all -all -memories -shm -database waves" >> shm.tcl
	@echo "run 18 ms -absolute" >> shm.tcl
	@echo "exit" >> shm.tcl

clean:
	rm -rf INCA_libs *.log *.key shm.tcl *.shm xcelium.d xrun.* .simvision
