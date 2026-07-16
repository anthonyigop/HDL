`timescale 1ns / 1ps

module tb_compare_alu;
    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] op;
    wire [3:0] result;
    wire zero;
    wire eq;
    wire gt;
    wire lt;

    integer i;

    comparator4 cmp (.a(a), .b(b), .eq(eq), .gt(gt), .lt(lt));
    alu4 alu (.a(a), .b(b), .op(op), .result(result), .zero(zero));

    initial begin
        $dumpfile("lab05_compare_alu.vcd");
        $dumpvars(0, tb_compare_alu);

        $display("=== Lab 05: Comparator and ALU Testbench ===");
        $display("");
        $display(" a  b  op | result zero  eq  gt  lt");
        $display("--------------------------------------");

        // Test a=9, b=3 with all 5 ALU operations
        a = 4'd9;
        b = 4'd3;
        for (i = 0; i < 5; i = i + 1) begin
            op = i[2:0];
            #10;
            $display("%2d %2d  %b |   %2d    %b   %b   %b   %b",
                a, b, op, result, zero, eq, gt, lt);
        end

        // Test a=5, b=5 — subtraction gives zero
        a = 4'd5;
        b = 4'd5;
        op = 3'b001;
        #10;
        $display("%2d %2d  %b |   %2d    %b   %b   %b   %b",
            a, b, op, result, zero, eq, gt, lt);

        // Challenge: NOT a on a=5
        op = 3'b100;
        #10;
        $display("%2d %2d  %b |   %2d    %b   %b   %b   %b",
            a, b, op, result, zero, eq, gt, lt);

        // Challenge: NOT a=1010 -> ~1010 = 0101 = 5
        a = 4'b1010;
        b = 4'b0000;
        op = 3'b100;
        #10;
        $display("%2d %2d  %b |   %2d    %b   %b   %b   %b",
            a, b, op, result, zero, eq, gt, lt);

        $display("");
        $display("=== Simulation Complete ===");
        $finish;
    end
endmodule
