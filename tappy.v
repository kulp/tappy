`default_nettype none

module tappy(input reset, sysclk, clk, dat, output byte word, output reg done);

    enum {
        RSET,
        IDLE,
        PROC,
        PRTY,
        DONE
    } state;

    initial state = RSET;

    reg [1:0] clocks;
    byte shift;

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
        word = {dat,word[7:1]};
        shift = {1'b1,shift[7:1]};
        if (shift[0])
            state = PRTY;
    endtask

    task check_parity;
        if (dat == ~^word)
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
        word = 0;
        done = 0;
        shift = 0;
        clocks = 0;
        state = IDLE;
    endtask

    always @(posedge sysclk)
        if (reset)
            reset_state;
        else
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

