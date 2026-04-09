`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 10:31:29 AM
// Design Name: 
// Module Name: leds
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



module leds(
    input clk,
    input rst,
    input [31:0] data_in,
    output reg [31:0] leds_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        leds_out <= 32'b0;
    else
        leds_out <= data_in;
end

endmodule