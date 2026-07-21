`timescale 1ns / 1ps

module traffic_light_controller (
    input  wire       clk,
    input  wire       reset,
    input  wire       ped_request,
    output reg  [2:0] main_light,
    output reg  [2:0] side_light,
    output reg        walk_light
);

    localparam [2:0] RED    = 3'b100,
                     YELLOW = 3'b010,
                     GREEN  = 3'b001;

    localparam [1:0] S_TRAIN_GO   = 2'b00,
                     S_TRAIN_WARN = 2'b01,
                     S_BOAT_GO    = 2'b10,
                     S_BOAT_WARN  = 2'b11;

    reg [1:0] state, next_state;
    reg [4:0] counter;
    reg       boat_latched;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= S_TRAIN_GO;
            counter      <= 5'd0;
            boat_latched <= 1'b0;
        end else begin
            state <= next_state;
            if (state != next_state) begin
                counter <= 5'd0;
            end else begin
                counter <= counter + 5'd1;
            end
            if (ped_request) begin
                boat_latched <= 1'b1;
            end else if (state == S_TRAIN_GO && next_state == S_TRAIN_WARN) begin
                boat_latched <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_TRAIN_GO: begin
                if (boat_latched && (counter >= 5 - 1))
                    next_state = S_TRAIN_WARN;
                else if (!boat_latched && (counter >= 20 - 1))
                    next_state = S_TRAIN_WARN;
            end
            S_TRAIN_WARN: begin
                if (counter >= 4 - 1)
                    next_state = S_BOAT_GO;
            end
            S_BOAT_GO: begin
                if (counter >= 10 - 1)
                    next_state = S_BOAT_WARN;
            end
            S_BOAT_WARN: begin
                if (counter >= 4 - 1)
                    next_state = S_TRAIN_GO;
            end
        endcase
    end

    always @(*) begin
        main_light = RED;
        side_light = RED;
        walk_light = 1'b0;
        case (state)
            S_TRAIN_GO: begin
                main_light = GREEN;
                side_light = RED;
            end
            S_TRAIN_WARN: begin
                main_light = YELLOW;
                side_light = RED;
            end
            S_BOAT_GO: begin
                main_light = RED;
                side_light = GREEN;
                walk_light = 1'b1;
            end
            S_BOAT_WARN: begin
                main_light = RED;
                side_light = YELLOW;
                walk_light = 1'b1;
            end
        endcase
    end

endmodule
