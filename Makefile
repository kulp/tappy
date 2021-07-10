.DELETE_ON_ERROR:

all: test

run: run_test

test: parse.v top.v

IVERILOGFLAGS += -g2012

%: %.v
	iverilog $(IVERILOGFLAGS) -o $@ $^

run_%: %
	$(realpath $<)

clean:
	$(RM) test
