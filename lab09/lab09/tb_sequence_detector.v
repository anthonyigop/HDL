`timescale 1ns / 1ps

module tb_sequence_detector;
    reg clk;
    reg reset;
    reg bit_in;
    wire detected;

    reg [15:0] stream;
    integer i;

    sequence_detector_1101 uut (
        .clk(clk),
        .reset(reset),
        .bit_in(bit_in),
        .detected(detected)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("lab09_sequence_detector.vcd");
        $dumpvars(0, tb_sequence_detector);

        $display("Time clk reset bit_in detected state next_state");
        $display("----------------------------------------------");

        reset = 1'b1;
        bit_in = 1'b0;
        stream = 16'b1101_1011_0110_1101;
        #12;
        reset = 1'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            bit_in = stream[i];
            #10;
            $display("%4t  %b    %b     %b       %b       %d    %d",
                     $time, clk, reset, bit_in, detected, uut.state, uut.next_state);
        end

        $display("----------------------------------------------");
        $display("Simulation complete.");
        $finish;
    end
endmodule
