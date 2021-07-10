`default_nettype none
`timescale 10us/1us

module test(output clk, dat);

    string logfile = "test.vcd";

    initial begin
        $display("Starting test");
        $dumpfile(logfile);
        $dumpvars;
    end

endmodule
