`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 11:08:03 AM
// Design Name: 
// Module Name: MainControl
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

/// TASK2 CHANGE//
module MainControl(
    input [6:0] opcode,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg Branch,
    output reg JAL,
    output reg [1:0] ALUOp
);
always @(*) begin
    case(opcode)
        7'b0110011: begin // R-type
            RegWrite = 1;
            ALUSrc   = 0;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;
            JAL      = 0;
            ALUOp    = 2'b10;
        end
        7'b0010011: begin // ADDI
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;
            JAL      = 0;
            ALUOp    = 2'b10;
        end
        7'b0000011: begin // Load
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
            MemWrite = 0;
            MemtoReg = 1;
            Branch   = 0;
            JAL      = 0;
            ALUOp    = 2'b00;
        end
        7'b0100011: begin // Store
            RegWrite = 0;
            ALUSrc   = 1;
            MemRead  = 0;
            MemWrite = 1;
            MemtoReg = 0;
            Branch   = 0;
            JAL      = 0;
            ALUOp    = 2'b00;
        end
        7'b1100011: begin // BEQ / BLT -- Original: BEQ only, TASK2: added BLT support via funct3 in ALUControl
            RegWrite = 0;
            ALUSrc   = 0;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 1;
            JAL      = 0;
            ALUOp    = 2'b01;
        end
        7'b1101111: begin // JAL -- TASK2 ADDITION
            RegWrite = 1;
            ALUSrc   = 0;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;
            JAL      = 1;
            ALUOp    = 2'b00;
        end
        7'b0110111: begin // LUI -- TASK2 ADDITION
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;
            JAL      = 0;
            ALUOp    = 2'b11; // special ALUOp for pass-through
        end
        default: begin
            RegWrite = 0;
            ALUSrc   = 0;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;
            JAL      = 0;
            ALUOp    = 2'b00;
        end
    endcase
end
endmodule