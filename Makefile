.DELETE_ON_ERROR:

all: test

run: run_test

test: tappy.v top.v

verilate: tappy.v
	verilator --cc $^

yosys: synthed.v

synthed.v: tappy.v
	yosys $(foreach p,$^,-p "read_verilog -sv $p") -p synth -p "write_verilog $@"

# Specify `+seed=123 +count=100` on the Make command line, for example.
PLUSARG_NAMES = $(filter +%,$(.VARIABLES))
# Use `$(origin ...)` to filter out some built-in variables like +D and +F.
PLUSARGS += $(foreach p,$(PLUSARG_NAMES),$(if $(findstring command line,$(origin $p)),$p=$($p)))

IVERILOGFLAGS += -g2012

%: %.v
	iverilog $(IVERILOGFLAGS) -o $@ $^

run_%: %
	$(realpath $<) $(PLUSARGS)

clean:
	$(RM) test
