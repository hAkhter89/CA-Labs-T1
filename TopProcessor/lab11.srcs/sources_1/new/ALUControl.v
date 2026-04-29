`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 11:09:40 AM
// Design Name: 
// Module Name: ALUControl
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

// TASK2 CHANGE (BLT, JAL, LUI(li))
module ALUControl(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7,
    input op5,            // to solve addi negative numbers, previous it treated it as a subtract instruction
    output reg [3:0] ALUControl,
    output reg BLT_taken  // TASK2 ADDITION: flag for BLT branch decision
);

always @(*) begin
    case(ALUOp)
        2'b00: begin
            ALUControl = 4'b0010; // ADD (Load/Store)
            BLT_taken  = 0;
        end
        2'b01: begin // Branch operations
            case(funct3)
                3'b000: begin  // BEQ -- ORIGINAL
                    ALUControl = 4'b0110; // SUB
                    BLT_taken  = 0;
                end
                3'b100: begin  // BLT -- TASK2 ADDITION
                    ALUControl = 4'b0110; // SUB, sign bit checked in PCSrc
                    BLT_taken  = 1;
                end
                default: begin
                    ALUControl = 4'b0110;
                    BLT_taken  = 0;
                end
            endcase
        end
        2'b10: begin // R-type / I-type operations
            BLT_taken = 0;
            case(funct3)
                3'b000: begin
                    // FIX Only subtract if it's an R-Type (op5 == 1) AND funct7 == 1
                    if(funct7 == 1 && op5 == 1)
                        ALUControl = 4'b0110; // SUB
                    else
                        ALUControl = 4'b0010; // ADD
                end
                3'b111: ALUControl = 4'b0000; // AND
                3'b110: ALUControl = 4'b0001; // OR
                3'b100: ALUControl = 4'b0011; // XOR
                3'b001: ALUControl = 4'b0100; // SLL
                3'b101: ALUControl = 4'b0101; // SRL
                default: ALUControl = 4'b0010;
            endcase
        end
        2'b11: begin // LUI -- TASK2 ADDITION: pass immediate through ALU
            ALUControl = 4'b1000;
            BLT_taken  = 0;
        end
        default: begin
            ALUControl = 4'b0010;
            BLT_taken  = 0;
        end
    endcase
end
endmodule
