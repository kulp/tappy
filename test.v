`default_nettype none
`timescale 10us/1us

module test(output clk, dat);

    string logfile = "test.vcd";

    reg clk = 1;
    reg dat = 1;
    reg parity = 1;

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
        begin
            push_bit(word[i]);
            parity ^= word[i];
        end
        push_bit(parity);
        parity = 1;
        push_bit(1);
        clk = 1;
    endtask

    initial begin
        $display("Starting test");
        $dumpfile(logfile);
        $dumpvars;

        for (integer j = 0; j < 16; j++)
        begin
            #4;
            push_byte(j);
            #4;
        end

        $finish;
    end

endmodule

