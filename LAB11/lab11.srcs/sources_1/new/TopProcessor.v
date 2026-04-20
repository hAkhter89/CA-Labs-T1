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
    input wire rst,
    output [15:0] LEDs,
    output wire dummy
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

//DATAPATH


// ALU
ALU alu_inst (
    .A(readData1),
    .B(ALU_B),
    .ALU_control(ALUctrl),
    .ALU_result(ALUResult),
    .Zero(zero)
);

// REGISTER FILE
Register reg_file_inst (
    .clk(clk),
    .rst(rst),
    .WriteEnable(RegWrite),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(instruction[11:7]),
    .WriteData(writeData),
    .ReadData1(readData1),
    .ReadData2(readData2)
);

// DATA MEMORY
DataMemory data_mem_inst (
    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .address(ALUResult[8:0]),
    .write_data(readData2),
    .read_data(mem_readData)
);

// MAIN CONTROL
MainControl main_ctrl_inst (
    .opcode(instruction[6:0]),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ALUOp(ALUOp)
);

// ALU CONTROL
ALUControl alu_ctrl_inst (
    .ALUOp(ALUOp),
    .funct3(instruction[14:12]),
    .funct7(instruction[30]),
    .ALUControl(ALUctrl)
);

// INSTRUCTION MEMORY
instructionMemory inst_mem (
    .instAddress(PCout),
    .instruction(instruction)
);

// ALU MUX (ALUSrc select)
branch_MUX alu_mux_inst (
    .in1(readData2),
    .in2(imm),
    .select(ALUSrc),
    .out(ALU_B)
);

// PC
PC pc_inst (
    .clk(clk),
    .rst(rst),
    .next(next),
    .PCout(PCout)
);

// PC ADDER (PC + 4)
PCAdder pc_adder_inst (
    .PCout(PCout),
    .PC4(PC4)
);

// BRANCH ADDER (PC + imm)
BranchAdd branch_add_inst (
    .PCout(PCout),
    .imm(imm),
    .target(target)
);

// BRANCH MUX (next PC select)
branch_MUX branch_mux_inst (
    .in1(PC4),
    .in2(target),
    .select(PCSrc),
    .out(next)
);

// MEM-TO-REG MUX (writeback select)
branch_MUX memtoreg_mux_inst (
    .in1(ALUResult),
    .in2(mem_readData),
    .select(MemtoReg),
    .out(writeData)
);

// IMMEDIATE GENERATOR
immGen imm_gen_inst (
    .instruction(instruction),
    .imm(imm)
);

assign LEDs   = ALUResult[15:0];
assign PCSrc  = Branch & zero;


endmodule
// DATAPATH, RTL, TIMING, UTILIZATION
