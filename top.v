`default_nettype none
`timescale 10us/1us

module top;

    wire clk;
    wire dat;

    reg sysclk = 0;
    always #2 sysclk = ~sysclk;

    test  t(.clk, .dat);
    parse p(.clk, .dat, .sysclk);

endmodule

