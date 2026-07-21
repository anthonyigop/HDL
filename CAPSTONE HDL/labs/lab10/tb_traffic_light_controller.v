`timescale 1ns / 1ps

module tb_traffic_light_controller;

    reg        clk;
    reg        reset;
    reg        ped_request;
    wire [2:0] main_light;
    wire [2:0] side_light;
    wire       walk_light;

    traffic_light_controller uut (
        .clk         (clk),
        .reset       (reset),
        .ped_request (ped_request),
        .main_light  (main_light),
        .side_light  (side_light),
        .walk_light  (walk_light)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        $display("t=%0t state=%b counter=%0d latched=%b main=%b side=%b walk=%b ped=%b",
                  $time, uut.state, uut.counter, uut.boat_latched,
                  main_light, side_light, walk_light, ped_request);
    end

    initial begin
        $dumpfile("tb_traffic_light_controller.vcd");
        $dumpvars(0, tb_traffic_light_controller);

        clk = 0;
        reset = 1;
        ped_request = 0;
        #20 reset = 0;

        #380;

        #5  ped_request = 1;
        #10 ped_request = 0;

        #230;

        #60;

        $finish;
    end

endmodule
