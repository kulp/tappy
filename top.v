`default_nettype none
`timescale 10us/1us

module top;

    wire clk;
    wire dat;

    reg sysclk = 0;
    // If the sysclk is at least four times as fast as the measured clock,
    // then there is no phase relationship required between sysclk and clk.
    always #1 sysclk = ~sysclk;

    test  t(.clk, .dat);
    parse p(.clk, .dat, .sysclk);

endmodule

