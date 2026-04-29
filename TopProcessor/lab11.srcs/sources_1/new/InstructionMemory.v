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

    initial begin
        $readmemh("instructions_task1.mem", memory);
    end

    always @(*) begin
        instruction = { memory[instAddress[7:0]],
                        memory[instAddress[7:0] + 1],
                        memory[instAddress[7:0] + 2],
                        memory[instAddress[7:0] + 3] };
    end

endmodule