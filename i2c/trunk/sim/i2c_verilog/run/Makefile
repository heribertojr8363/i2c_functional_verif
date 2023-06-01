# Caminho para os diretórios dos arquivos
I2C_DIR = ../../..
BENCH_DIR = $(I2C_DIR)/bench

# Flags para o Xcelium
XCELIUM_FLAGS = -access rwc \
	+incdir+$(BENCH_DIR)/verilog \
	+incdir+$(I2C_DIR)/rtl/verilog \
	-input shm.tcl

# Arquivos fonte
RTL_FILES = $(I2C_DIR)/rtl/verilog/i2c_master_bit_ctrl.v \
	$(I2C_DIR)/rtl/verilog/i2c_master_byte_ctrl.v \
	$(I2C_DIR)/rtl/verilog/i2c_master_top.v

BENCH_FILES = $(BENCH_DIR)/verilog/i2c_slave_model.v \
	$(BENCH_DIR)/verilog/wb_master_model.v \
	$(BENCH_DIR)/verilog/tst_bench_top.v

# Comando para executar o Xcelium
XCELIUM_CMD = xrun -sv $(XCELIUM_FLAGS)

all:
	$(XCELIUM_CMD) $(RTL_FILES) $(BENCH_FILES)

waves:
	simvision waves.shm

create_tcl:
	@echo "database -open waves -shm" >> shm.tcl
	@echo "probe -create tst_bench_top -depth all -all -memories -shm -database waves" >> shm.tcl
	@echo "run 18 ms -absolute" >> shm.tcl
	@echo "exit" >> shm.tcl

clean:
	rm -rf INCA_libs *.log *.key shm.tcl *.shm xcelium.d xrun.* .simvision
