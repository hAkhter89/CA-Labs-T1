`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 11:12:08 AM
// Design Name: 
// Module Name: InstructionMemory
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


module instructionMemory#(
    parameter OPERAND_LENGTH = 31
    )(
    input [OPERAND_LENGTH:0] instAddress,
    output reg [31:0] instruction
);

reg [7:0] memory [0:255];

    always @(*) begin
        instruction = { memory[instAddress + 3],
                        memory[instAddress + 2],
                        memory[instAddress + 1],
                        memory[instAddress + 0] }; // LITTLE END-IAN FORMAT
    end

    // Initialize memory
    initial begin
        // Load from external file
        // $readmemh("instructions.mem", memory);
        memory[0] = 8'h93;
        memory[1] = 8'h00;
        memory[2] = 8'h50;
        memory[3] = 8'h00;

    end


endmodule
