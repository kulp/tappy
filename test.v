`default_nettype none
`timescale 10us/1us

module test(output clk, dat);

    string logfile = "test.vcd";

    reg clk = 1;
    reg dat = 1;

    // Bits are pushed out on posedge, and should be read on negedge.
    task push_bit(input b);
        #2 dat = b;
        #2 clk = 0;
        #4 clk = 1;
    endtask

    task push_byte(byte word);
        integer i;
        push_bit(0);
        for (i = 0; i < 8; i = i + 1)
            push_bit(word[i]);
        push_bit(1);
    endtask

    initial begin
        $display("Starting test");
        $dumpfile(logfile);
        $dumpvars;
    end

endmodule
