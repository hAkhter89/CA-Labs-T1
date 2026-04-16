`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2026 08:32:46 PM
// Design Name: 
// Module Name: led
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
    input [31:0] writeData,
    input writeEnable,
    input readEnable,
    input [29:0] memAddress,
    output reg [31:0] readData = 0,       
    output reg [15:0] leds
);
    reg [7:0] ledData [3:0];
    
    always @(posedge clk) begin
        if (rst) begin
            leds <= 16'd0;
        end else if (writeEnable) begin
            leds <= writeData[15:0];
        end
    end
endmodule
