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

    task start;
        $display("Idle");
        state = PROC;
        if (dat != 0)
        begin
            $display("Bad (non-zero) start bit");
            $stop;
        end
    endtask

    task handle_bit;
        $display("Within word");
        parity ^= dat;
        word = {dat,word[7:1]};
        if (count == 7)
            state = PRTY;
        count++;
    endtask

    task check_parity;
        $display("Checking parity");
        if (dat == parity)
            state = DONE;
        else
        begin
            $display("Bad parity");
            state = RSET;
            $stop;
        end
    endtask

    task finish_word;
        if (dat != 1)
        begin
            $display("Bad (zero) stop bit");
            $stop;
        end
        $display("word=",word);
        done = 1;
        state = RSET;
    endtask

    task reset_state;
        $display("Resetting");
        parity = 1;
        word = 0;
        done = 0;
        count = 0;
        prevclk = 0;
        state = IDLE;
    endtask

    always @(posedge sysclk)
    begin
        casez ({state,prevclk,clk})
            {IDLE,2'b10}: start;
            {PROC,2'b10}: handle_bit;
            {PRTY,2'b10}: check_parity;
            {DONE,2'b10}: finish_word;
            {RSET,2'b??}: reset_state;

            default: /* do nothing */;
        endcase

        prevclk = clk;
    end

endmodule

