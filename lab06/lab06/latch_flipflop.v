`timescale 1ns / 1ps

module d_latch(
    input d,
    input enable,
    output reg q_latch
);
    always @(*) begin
        if (enable) begin
            q_latch = d;
        end
    end
endmodule

module d_flip_flop(
    input d,
    input clk,
    input reset,
    output reg q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end
endmodule

module dff_async_reset(
    input d,
    input clk,
    input reset_n,
    output reg q_ff
);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            q_ff <= 1'b0;
        end else begin
            q_ff <= d;
        end
    end
endmodule
