`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 10:34:18 AM
// Design Name: 
// Module Name: 2_MUX
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


module branch_MUX(
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire select,
    output wire [31:0] out
);
    assign out = select ? in2 : in1; // 0 = increment PC, 1 = branch instruction select
endmodule
