.DELETE_ON_ERROR:

all: test

run: run_test

test: tappy.v top.v

verilate: tappy.v
	verilator --cc $^

IVERILOGFLAGS += -g2012

%: %.v
	iverilog $(IVERILOGFLAGS) -o $@ $^

run_%: %
	$(realpath $<)

clean:
	$(RM) test
