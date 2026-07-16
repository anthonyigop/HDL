`timescale 1ns / 1ps

module tb_shift_register;
    reg clk;
    reg reset;
    reg load;
    reg direction;
    reg serial_in;
    reg [3:0] parallel_in;
    wire [3:0] q;
    wire serial_out;

    shift_register4 uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .direction(direction),
        .serial_in(serial_in),
        .parallel_in(parallel_in),
        .q(q),
        .serial_out(serial_out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    always @(posedge clk) begin
        $strobe("%0t\t %b\t %b\t %b\t %b\t %b\t\t %b\t %b\t %b",
                $time, clk, reset, load, direction, serial_in, parallel_in, q, serial_out);
    end

    initial begin
        $dumpfile("lab08_shift_register.vcd");
        $dumpvars(0, tb_shift_register);

        $display("");
        $display("               Lab 08 - Shift Register Testbench with Challenge");
        $display("           =======================================================");
        $display("");
        $display(" Time\tclk\trst\tload\tdirection\ts_in\tp_in\t q\ts_out");
        $display("---------------------------------------------------------------");

        clk = 1'b0;
        reset = 1'b1;
        load = 1'b0;
        direction = 1'b0;
        serial_in = 1'b0;
        parallel_in = 4'b1010;

        // --- 1. Synchronous Reset (first posedge at t=5) ---
        #10;
        reset = 1'b0;

        // --- 2. Parallel Load ---
        #10;
        load = 1'b1;
        #10;
        load = 1'b0;

        // --- 3. Shift Right (direction=0) with serial_in=1 ---
        serial_in = 1'b1;
        direction = 1'b0;
        #10;
        #10;
        #10;

        // --- 4. Load a distinct pattern for shift-left test ---
        load = 1'b1;
        parallel_in = 4'b0110;
        serial_in = 1'b0;
        #10;

        // --- 5. Shift Left (direction=1) with alternating serial_in ---
        load = 1'b0;
        direction = 1'b1;
        serial_in = 1'b0;
        #10;
        serial_in = 1'b1;
        #10;
        serial_in = 1'b0;
        #10;
        serial_in = 1'b1;
        #10;
        serial_in = 1'b0;
        #10;

        $finish;
    end
endmodule
