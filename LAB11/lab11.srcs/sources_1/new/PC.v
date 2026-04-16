`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 10:25:54 AM
// Design Name: 
// Module Name: PC
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


module PC(
    input wire clk,
    input wire rst,
    input wire [31:0] next,
    output reg [31:0] PCout
);

    always @(posedge clk) begin
        if (rst)
            PCout <= 32'd0;
        else
            PCout <= next;
    end 
endmodule
