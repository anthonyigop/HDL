`timescale 1ns / 1ps

module tb_latch_flipflop;
    reg d;
    reg enable;
    reg clk;
    reg reset;
    reg reset_n;
    wire q_latch;
    wire q_ff_sync;
    wire q_ff_async;

    d_latch latch0 (.d(d), .enable(enable), .q_latch(q_latch));
    d_flip_flop ff0 (.d(d), .clk(clk), .reset(reset), .q(q_ff_sync));
    dff_async_reset ff1 (.d(d), .clk(clk), .reset_n(reset_n), .q_ff(q_ff_async));

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("lab06_latch_flipflop.vcd");
        $dumpvars(0, tb_latch_flipflop);

        d       = 1'b0;
        enable  = 1'b0;
        reset   = 1'b1;
        reset_n = 1'b0;
        #12;

        reset   = 1'b0;
        reset_n = 1'b1;
        #10;

        enable = 1'b1;
        d = 1'b1;
        #12;

        enable = 1'b0;
        d = 1'b0;
        #10;

        enable = 1'b1;
        #14;

        d = 1'b1;
        #3;

        reset_n = 1'b0;
        #4;

        reset_n = 1'b1;
        #13;

        d = 1'b0;
        #10;

        d = 1'b1;
        #10;

        $finish;
    end
endmodule
