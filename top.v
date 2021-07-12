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
    byte compare;
    reg done;

    test  t(.clk, .dat, .compare);
    tappy p(.clk, .dat, .sysclk, .word, .done);

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

