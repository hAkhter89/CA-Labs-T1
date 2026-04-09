`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2026 10:56:53 AM
// Design Name: 
// Module Name: maincontrol
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


module MainControl(
    input [6:0] opcode,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg Branch,
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
            ALUOp    = 2'b10;
        end

        7'b0010011: begin // ADDI
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;
            ALUOp    = 2'b10;
        end

        7'b0000011: begin // Load
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
            MemWrite = 0;
            MemtoReg = 1;
            Branch   = 0;
            ALUOp    = 2'b00;
        end

        7'b0100011: begin // Store
            RegWrite = 0;
            ALUSrc   = 1;
            MemRead  = 0;
            MemWrite = 1;
            MemtoReg = 0; //safe
            Branch   = 0;
            ALUOp    = 2'b00;
        end

        7'b1100011: begin // BEQ
            RegWrite = 0;
            ALUSrc   = 0;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0; //safe
            Branch   = 1;
            ALUOp    = 2'b01;
        end
    endcase
end

endmodule

