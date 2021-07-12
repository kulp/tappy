`default_nettype none
`timescale 1us/100ns

module test(output clk, dat, output byte compare);

    string logfile = "test.vcd";

    reg clk = 1;
    reg dat = 1;

    real freq;

    task DELAY(real n);
        #(n * 1_000_000.0 / freq);
    endtask

    // Bits are pushed out on posedge, and should be read on negedge.
    task push_bit(input b);
        DELAY(0.25); dat = b;
        DELAY(0.25); clk = 0;
        DELAY(0.50); clk = 1;
    endtask

    task push_byte(byte word);
        integer i;
        push_bit(0);
        for (i = 0; i < 8; i = i + 1)
            push_bit(word[i]);
        push_bit(~^word);
        push_bit(1);
        clk = 1;
    endtask

    initial begin
        $display("Starting test");
        $dumpfile(logfile);
        $dumpvars(0, top);

        for (integer j = 0; j < $urandom_range(100,10); j++)
        begin
            freq = $urandom_range(MAX_FREQ, MIN_FREQ);
            compare = $urandom();
            push_byte(compare);
            DELAY($urandom_range(20));
        end

        $finish;
    end

endmodule

