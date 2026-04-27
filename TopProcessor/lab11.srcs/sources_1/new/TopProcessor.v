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
    output wire [15:0] LEDs
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
wire [31:0] target; // branch_target
// Task2 wires
wire JAL;
wire BLT_taken;
wire [31:0] writeData_final;


assign PCSrc = (Branch & zero) | (Branch & BLT_taken & ALUResult[31]) | JAL; // TASK2 CHANGE

// DATA PATH //

// ALU
ALU alu_inst (
    .A(readData1),
    .B(ALU_B),
    .ALU_control(ALUctrl),
    .ALU_result(ALUResult),
    .Zero(zero)
);

// REGISTERFILE
Register reg_file_inst (
    .clk(clk),
    .rst(rst),
    .WriteEnable(RegWrite),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(instruction[11:7]),
    .WriteData(writeData_final), // TASK2 CHANGE
    .ReadData1(readData1),
    .ReadData2(readData2)
);

// DATAMEMORY
DataMemory data_mem_inst (
    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .funct3(instruction[14:12]), // Pass the funct3 bits from your instruction
    .address(ALUResult),         // Pass the full 32-bit ALU result
    .write_data(readData2),
    .read_data(mem_readData)
);

// MAINCONTROL
MainControl main_ctrl_inst (
    .opcode(instruction[6:0]),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ALUOp(ALUOp),
    .JAL(JAL) // TASK2 CHANGE
);

// ALUCONTROL
ALUControl alu_ctrl_inst (
    .ALUOp(ALUOp),
    .funct3(instruction[14:12]),
    .funct7(instruction[30]),
    .ALUControl(ALUctrl),
    .BLT_taken(BLT_taken) // TASK2 CHANGE
);

// INSTRUCTIONMEMORY
instructionMemory inst_mem (
    .instAddress(PCout),
    .instruction(instruction)
);

// ALU_MUX
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

// PCAdder
PCAdder pc_adder_inst (
    .PCout(PCout),
    .PC4(PC4)
);

// BranchAdd
BranchAdd branch_add_inst (
    .PCout(PCout),
    .imm(imm),
    .target(target)
);

// BranchMUX
branch_MUX branch_mux_inst (
    .in1(PC4),
    .in2(target),
    .select(PCSrc),
    .out(next)
);

// MEMtoREG_MUX
branch_MUX memtoreg_mux_inst (
    .in1(ALUResult),
    .in2(mem_readData),
    .select(MemtoReg),
    .out(writeData)
);

// JAL MUX - TASK 2 ADDITION
branch_MUX jal_mux_inst (
    .in1(writeData),
    .in2(PC4),
    .select(JAL),
    .out(writeData_final)
);

// immGen
immGen imm_gen_inst (
    .instruction(instruction),
    .imm(imm)
);



assign LEDs = ALUResult[15:0];
endmodule
//assign dummy = |ALUResult | |PCout;

//module topProcessor(
//    input wire clk,
//    input wire rst,
//    output wire [15:0] LEDs
//);

//// =====================
//// PC WIRES
//// =====================
//wire [31:0] PCout, PC4, next;
//wire [31:0] instruction;
//wire [31:0] target;

//// =====================
//// CONTROL WIRES
//// =====================
//wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
//wire [1:0] ALUOp;
//wire [3:0] ALUctrl;
//wire zero;

//// =====================
//// REGISTER WIRES
//// =====================
//wire [31:0] imm;
//wire [31:0] readData1, readData2, writeData;

//// =====================
//// ALU WIRES
//// =====================
//wire [31:0] ALU_B, ALUResult;

//// =====================
//// PC LOGIC (REAL CPU)
//// =====================

//assign PC4 = PCout + 32'd4;
//assign target = PCout + imm;

//assign next = (Branch & zero) ? target : PC4;

//// =====================
//// PC
//// =====================
//PC pc_inst (
//    .clk(clk),
//    .rst(rst),
//    .next(next),
//    .PCout(PCout)
//);

//// =====================
//// INSTRUCTION MEMORY
//// =====================
//instructionMemory inst_mem (
//    .instAddress(PCout),
//    .instruction(instruction)
//);

//// =====================
//// CONTROL UNIT
//// =====================
//MainControl main_ctrl_inst (
//    .opcode(instruction[6:0]),
//    .RegWrite(RegWrite),
//    .ALUSrc(ALUSrc),
//    .MemRead(MemRead),
//    .MemWrite(MemWrite),
//    .MemtoReg(MemtoReg),
//    .Branch(Branch),
//    .ALUOp(ALUOp)
//);

//// =====================
//// REGISTER FILE
//// =====================
//Register reg_file_inst (
//    .clk(clk),
//    .rst(rst),
//    .WriteEnable(RegWrite),
//    .rs1(instruction[19:15]),
//    .rs2(instruction[24:20]),
//    .rd(instruction[11:7]),
//    .WriteData(writeData),
//    .ReadData1(readData1),
//    .ReadData2(readData2)
//);

//// =====================
//// IMMEDIATE GENERATOR
//// =====================
//immGen imm_gen_inst (
//    .instruction(instruction),
//    .imm(imm)
//);

//// =====================
//// ALU CONTROL
//// =====================
//ALUControl alu_ctrl_inst (
//    .ALUOp(ALUOp),
//    .funct3(instruction[14:12]),
//    .funct7(instruction[30]),
//    .ALUControl(ALUctrl)
//);

//// =====================
//// ALU INPUT MUX
//// =====================
//assign ALU_B = (ALUSrc) ? imm : readData2;

//// =====================
//// ALU
//// =====================
//ALU alu_inst (
//    .A(readData1),
//    .B(ALU_B),
//    .ALU_control(ALUctrl),
//    .ALU_result(ALUResult),
//    .Zero(zero)
//);

//// =====================
//// WRITEBACK MUX
//// =====================
//assign writeData = (MemtoReg) ? 32'd0 : ALUResult;

//// =====================
//// LED OUTPUT
//// =====================
//assign LEDs = ALUResult[15:0];

//endmodule


