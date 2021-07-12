`default_nettype none

module tappy(input sysclk, clk, dat, output byte word, output reg done);

    enum {
        RSET,
        IDLE,
        PROC,
        PRTY,
        DONE
    } state = RSET;

    reg parity;
    reg [1:0] clocks;
    byte count;

    task start;
        if (dat == 0)
            state = PROC;
        else
        begin
            $display("Bad (non-zero) start bit");
            $stop;
            state = RSET;
        end
    endtask

    task handle_bit;
        parity ^= dat;
        word = {dat,word[7:1]};
        if (count == 7)
            state = PRTY;
        count++;
    endtask

    task check_parity;
        if (dat == parity)
            state = DONE;
        else
        begin
            $display("Bad parity");
            $stop;
            state = RSET;
        end
    endtask

    task finish_word;
        if (dat == 1)
        begin
            done = 1;
            state = RSET;
        end
        else
        begin
            $display("Bad (zero) stop bit");
            $stop;
            state = RSET;
        end
    endtask

    task reset_state;
        parity = 1;
        word = 0;
        done = 0;
        count = 0;
        clocks = 0;
        state = IDLE;
    endtask

    always @(posedge sysclk)
    begin
        clocks = {clocks[0],clk};

        casez ({state,clocks})
            {IDLE,2'b10}: start;
            {PROC,2'b10}: handle_bit;
            {PRTY,2'b10}: check_parity;
            {DONE,2'b10}: finish_word;
            {RSET,2'b??}: reset_state;

            default: /* do nothing */;
        endcase
    end

endmodule

