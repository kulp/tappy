`default_nettype none
`timescale 10us/1us

module top;

    wire clk;
    wire dat;

    reg sysclk = 0;
    // If the sysclk is at least four times as fast as the measured clock,
    // then there is no phase relationship required between sysclk and clk.
    always #1 sysclk = ~sysclk;

    byte word;
    reg done;

    test  t(.clk, .dat);
    parse p(.clk, .dat, .sysclk, .word, .done);

    always @(posedge sysclk)
    begin
        if (done)
            $display("word=", word);
    end

endmodule

