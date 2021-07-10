`default_nettype none
`timescale 10us/1us

module parse(input sysclk, clk, dat, output byte word, output reg done);

    enum {
        RSET,
        IDLE,
        PROC,
        PRTY,
        DONE
    } state = RSET;

    reg parity;
    reg prevclk;
    byte count;

    always @(posedge sysclk)
    begin
        casez ({state,prevclk,clk})
            {IDLE,2'b10}:
                begin
                    $display("Idle");
                    state = PROC;
                    if (dat != 0)
                    begin
                        $display("Bad (non-zero) start bit");
                        $stop;
                    end
                end

            {PROC,2'b10}:
                begin
                    $display("Within word");
                    parity ^= dat;
                    word = {dat,word[7:1]};
                    if (count == 7)
                        state = PRTY;
                    count++;
                end

            {PRTY,2'b10}:
                begin
                    $display("Checking parity");
                    if (dat == parity)
                        state = DONE;
                    else
                    begin
                        $display("Bad parity");
                        state = RSET;
                        $stop;
                    end
                end

            {DONE,2'b10}:
                begin
                    if (dat != 1)
                    begin
                        $display("Bad (zero) stop bit");
                        $stop;
                    end
                    $display("word=",word);
                    done = 1;
                    state = RSET;
                end

            {RSET,2'b??}:
                begin
                    $display("Resetting");
                    parity = 1;
                    word = 0;
                    done = 0;
                    count = 0;
                    prevclk = 0;
                    state = IDLE;
                end

            default: /* do nothing */;
        endcase

        prevclk = clk;
    end

endmodule

