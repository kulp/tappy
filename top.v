`default_nettype none
`timescale 1us/100ns

parameter real MIN_FREQ = 10_000.0;
parameter real MAX_FREQ = 16_666.7;

module top;

    wire reset;
    wire clk;
    wire dat;

    reg sysclk = 0;
    // If the sysclk is at least four times as fast as the measured clock,
    // then there is no phase relationship required between sysclk and clk.
    // The `0.25` in the formula below represents the 4x clock; the division
    // by 2 represents the fact that the delay represents half a clock cycle.
    always #(0.25 / 2 * 1_000_000.0 / MAX_FREQ) sysclk = ~sysclk;

    byte word;
    byte compare;
    reg done;

    test  t(.clk, .dat, .compare, .reset);
    tappy p(.clk, .dat, .sysclk, .word, .done, .reset);

    always @(posedge sysclk)
    begin
        if (done)
        begin
            $display("word=", word);
            if (word != compare)
            begin
                $display("compare=", compare);
                $stop;
            end
        end
    end

endmodule

