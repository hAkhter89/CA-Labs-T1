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


module ALUControl(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7, // we only need to check its second bit
    output reg [3:0] ALUControl
);

always @(*) begin
    case(ALUOp)
        2'b00: ALUControl = 4'b0000; // ADD
        2'b01: ALUControl = 4'b0001; // SUB

        2'b10: begin
            case(funct3)
                3'b000: begin
                    if(funct7 == 1)
                        ALUControl = 4'b0001; // SUB
                    else
                        ALUControl = 4'b0000; // ADD
                end
                3'b111: ALUControl = 4'b0010; // AND
                3'b110: ALUControl = 4'b0011; // OR
                3'b100: ALUControl = 4'b0100; // XOR
                3'b001: ALUControl = 4'b0101; // SLL
                3'b101: ALUControl = 4'b0110; // SRL
                default: ALUControl = 4'b0000;
            endcase
        end

        default: ALUControl = 4'b0000;
    endcase
end

endmodule
