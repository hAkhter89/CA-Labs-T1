`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 10:31:18 AM
// Design Name: 
// Module Name: BranchAdd
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


module BranchAdd(
    input wire [31:0] PCout,
    input wire [31:0] imm,
    output wire [31:0] target
);
    assign target = PCout + imm;
endmodule
