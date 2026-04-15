`timescale 1ns/1ps

module task2_tb;

reg [6:0] opcode;
reg [2:0] funct3;
reg [6:0] funct7;
wire [3:0] ALUControl;

wire RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
wire [1:0] ALUOp;

MainControl mc(opcode, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp);
ALUControl alu(ALUOp, funct3, funct7, ALUControl);

initial begin
    // ADD
    opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000;
    #10;

    // SUB
    funct7 = 7'b0100000;
    #10;

    // AND
    funct3 = 3'b111;
    #10;

    // LW
    opcode = 7'b0000011;
    #10;

    // SW
    opcode = 7'b0100011;
    #10;

    // BEQ
    opcode = 7'b1100011;
    #10;

    $stop;
end

endmodule
