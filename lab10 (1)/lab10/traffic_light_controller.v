`timescale 1ns / 1ps

module traffic_light_controller(
    input clk,
    input reset,
    input ped_request,
    input school_zone_active,
    output reg [2:0] main_light,
    output reg [2:0] side_light,
    output reg walk_light
);

    localparam RED   = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN  = 3'b001;

    localparam [1:0] S_MAIN_GREEN  = 2'b00;
    localparam [1:0] S_MAIN_YELLOW = 2'b01;
    localparam [1:0] S_SIDE_GREEN  = 2'b10;
    localparam [1:0] S_SIDE_YELLOW = 2'b11;

    localparam [4:0] MG_NORMAL  = 5'd20;
    localparam [4:0] MG_PED     = 5'd5;
    localparam [4:0] MG_SCHOOL  = 5'd6;
    localparam [4:0] YLW_TICKS  = 5'd4;
    localparam [4:0] SG_NORMAL  = 5'd10;
    localparam [4:0] SG_SCHOOL  = 5'd14;

    reg [1:0] state;
    reg [4:0] timer;
    reg [4:0] limit;

    always @(*) begin
        case (state)
            S_MAIN_GREEN: begin
                main_light = GREEN;
                side_light = RED;
                walk_light = 1'b0;
                if (school_zone_active)
                    limit = MG_SCHOOL;
                else if (ped_request)
                    limit = MG_PED;
                else
                    limit = MG_NORMAL;
            end
            S_MAIN_YELLOW: begin
                main_light = YELLOW;
                side_light = RED;
                walk_light = 1'b0;
                limit = YLW_TICKS;
            end
            S_SIDE_GREEN: begin
                main_light = RED;
                side_light = GREEN;
                walk_light = 1'b1;
                if (school_zone_active)
                    limit = SG_SCHOOL;
                else
                    limit = SG_NORMAL;
            end
            S_SIDE_YELLOW: begin
                main_light = RED;
                side_light = YELLOW;
                walk_light = 1'b0;
                limit = YLW_TICKS;
            end
            default: begin
                main_light = GREEN;
                side_light = RED;
                walk_light = 1'b0;
                limit = MG_NORMAL;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_MAIN_GREEN;
            timer <= 5'd0;
        end else if (timer >= limit - 5'd1) begin
            timer <= 5'd0;
            case (state)
                S_MAIN_GREEN:  state <= S_MAIN_YELLOW;
                S_MAIN_YELLOW: state <= S_SIDE_GREEN;
                S_SIDE_GREEN:  state <= S_SIDE_YELLOW;
                S_SIDE_YELLOW: state <= S_MAIN_GREEN;
                default:       state <= S_MAIN_GREEN;
            endcase
        end else begin
            timer <= timer + 5'd1;
        end
    end

endmodule
