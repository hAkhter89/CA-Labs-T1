`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2026 02:03:14 PM
// Design Name: 
// Module Name: sevensegment
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module SevenSegment(
    input wire clk,
    input wire [15:0] data,         // upper 16 bits of ALUResult
    output reg [6:0] seg,
    output reg [3:0] an
);

reg [16:0] refresh_counter;
wire [1:0] digit_select;

// Refresh counter ~1kHz refresh rate
always @(posedge clk) begin
    refresh_counter <= refresh_counter + 1;
end

assign digit_select = refresh_counter[16:15];

reg [3:0] current_digit;

// Select which digit to display
always @(*) begin
    case(digit_select)
        2'b00: begin
            an = 4'b1110;                    // rightmost digit
            current_digit = data[3:0];       // bits 3:0
        end
        2'b01: begin
            an = 4'b1101;                    // second digit
            current_digit = data[7:4];       // bits 7:4
        end
        2'b10: begin
            an = 4'b1011;                    // third digit
            current_digit = data[11:8];      // bits 11:8
        end
        2'b11: begin
            an = 4'b0111;                    // leftmost digit
            current_digit = data[15:12];     // bits 15:12
        end
        default: begin
            an = 4'b1111;
            current_digit = 4'b0000;
        end
    endcase
end

// Hex to 7-segment decoder
// segments: gfedcba
always @(*) begin
    case(current_digit)
        4'h0: seg = 7'b1000000; // 0
        4'h1: seg = 7'b1111001; // 1
        4'h2: seg = 7'b0100100; // 2
        4'h3: seg = 7'b0110000; // 3
        4'h4: seg = 7'b0011001; // 4
        4'h5: seg = 7'b0010010; // 5
        4'h6: seg = 7'b0000010; // 6
        4'h7: seg = 7'b1111000; // 7
        4'h8: seg = 7'b0000000; // 8
        4'h9: seg = 7'b0010000; // 9
        4'hA: seg = 7'b0001000; // A
        4'hB: seg = 7'b0000011; // B
        4'hC: seg = 7'b1000110; // C
        4'hD: seg = 7'b0100001; // D
        4'hE: seg = 7'b0000110; // E
        4'hF: seg = 7'b0001110; // F
        default: seg = 7'b1111111;
    endcase
end

endmodule