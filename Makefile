# vhdl files
FILES = src/*
VHDLEX = .vhd

# testbench
TESTBENCHPATH = tb/${TESTBENCHFILE}$(VHDLEX)
TESTBENCHFILE = bench_decoder

#GHDL CONFIG
GHDL_CMD = ghdl

SIMDIR = simulation
STOP_TIME = 2000000ns

# Simulation break condition
GHDL_FLAGS  = --ieee=synopsys --std=08 --warn-no-vital-generic
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean make run view

compile:
	@$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simulation --work=lib_VHDL $(TESTBENCHPATH) $(FILES)
	@$(GHDL_CMD) -m  $(GHDL_FLAGS) --workdir=simulation --work=lib_VHDL $(TESTBENCHFILE)

make:
	@mkdir -p simulation
	make compile
	@mv $(TESTBENCHFILE) simulation/$(TESTBENCHFILE)

run:
	@$(SIMDIR)/$(TESTBENCHFILE) $(GHDL_SIM_OPT) --vcdgz=$(SIMDIR)/$(TESTBENCHFILE).vcdgz

view:
	@gunzip --stdout $(SIMDIR)/$(TESTBENCHFILE).vcdgz | $(WAVEFORM_VIEWER) --vcd

clean:
	@rm -rf $(SIMDIR)
