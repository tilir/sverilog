COMPILER := verilator

FILELIST = filelist_rmc 
SIMV = rmc
SRC = readmem_check.sv
OPTS = -cc --build --main --exe $(SRC) -o $(SIMV)

.PHONY: all
all: run

.PHONY: compile
compile: $(SIMV)

.PHONY: run
run: $(SIMV)
	./obj_dir/$(SIMV)

$(SIMV): $(SRC)
	$(COMPILER) $(OPTS)

.PHONY: clean
clean:
	rm -rf obj_dir
