.DELETE_ON_ERROR:

all: test

run: run_test

%: %.v
	iverilog $(IVERILOGFLAGS) -o $@ $^

run_%: %
	$(realpath $<)

clean:
	$(RM) test
