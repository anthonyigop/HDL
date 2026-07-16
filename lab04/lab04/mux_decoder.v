`timescale 1ns / 1ps

module mux4to1(
    input [3:0] data,
    input [1:0] sel,
    output reg y
);
    always @(*) begin
        case (sel)
            2'b00: y = data[0];
            2'b01: y = data[1];
            2'b10: y = data[2];
            2'b11: y = data[3];
            default: y = 1'b0;
        endcase
    end
endmodule

module decoder2to4(
    input [1:0] sel,
    input enable,
    output reg [3:0] y
);
    always @(*) begin
        if (enable) begin
            case (sel)
                2'b00: y = 4'b0001;
                2'b01: y = 4'b0010;
                2'b10: y = 4'b0100;
                2'b11: y = 4'b1000;
                default: y = 4'b0000;
            endcase
        end else begin
            y = 4'b0000;
        end
    end
endmodule

module mux8(
    input [7:0] data8,
    input [2:0] sel8,
    output reg mux8_y
);
    always @(*) begin
        case (sel8)
            3'b000: mux8_y = data8[0];
            3'b001: mux8_y = data8[1];
            3'b010: mux8_y = data8[2];
            3'b011: mux8_y = data8[3];
            3'b100: mux8_y = data8[4];
            3'b101: mux8_y = data8[5];
            3'b110: mux8_y = data8[6];
            3'b111: mux8_y = data8[7];
            default: mux8_y = 1'b0;
        endcase
    end
endmodule
