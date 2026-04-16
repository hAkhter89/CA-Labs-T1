`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 10:24:45 AM
// Design Name: 
// Module Name: topProcessor
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


module topProcessor(
    input wire clk,
    input wire rst
);
// PC wires
wire [31:0] PCout, next, PC4;
wire [31:0] instruction;
// Control wires
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
wire [3:0] ALUctrl;
wire PCSrc;
// Register wires
wire [31:0] imm;
wire [31:0] readData1, readData2, writeData;
// ALU wires
wire [31:0] ALU_B, ALUResult;
wire zero;
// Memory wires
wire [31:0] mem_readData;
wire [31:0] target; // branch



// DATA PATH //

// ALU
// REGISTERFILE
// DATAMEMORY 
// MAINCONTROL
// ALUCONTROL
// INSTRUCTIONMEMORY
// ALU_MUX
// PC
// PCAdder
// BranchAdd
// BranchMUX
// MEMtoREG_MUX
// immGen

assign PCSrc = Branch & zero;

endmodule
// DATAPATH, RTL, TIMING, UTILIZATION