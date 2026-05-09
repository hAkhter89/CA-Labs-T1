`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2026 12:43:37 PM
// Design Name: 
// Module Name: clockdivider
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


module clockdivider(
    input wire clk,
    input wire rst,
    output reg slow_clk
);

reg [26:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 27'd0;
        slow_clk <= 1'b0;
    end else if (counter == 27'd49_999_999) begin
        counter <= 27'd0;
        slow_clk <= ~slow_clk;
    end else begin
        counter <= counter + 1;
    end
end
endmodule    