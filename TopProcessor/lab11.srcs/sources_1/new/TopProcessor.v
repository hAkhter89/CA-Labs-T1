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
    input wire fast_clk,
    input wire rst,
    output wire [15:0] LEDs,
    input wire [15:0] SW,        // ADD switches
    output wire [6:0] seg,
    output wire [3:0] an,
    output wire dp
);

// PC wires
wire [31:0] PCout, next, PC4;
wire [31:0] instruction;

// Control wires
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
wire [3:0] ALUctrl;
wire op5 = instruction[5]; // fix for addi negative numbers
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
wire [31:0] counter_data; // <--- NEW: Wire to catch the memory[8] output

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
    .read_data(mem_readData),
    .mem8_out(counter_data),      // <--- NEW: Catch the memory data here
    .SW(SW)
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
    .BLT_taken(BLT_taken), // TASK2 CHANGE
    .op5(op5)
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

// SEVEN SEGMENT
SevenSegment seg_inst (
    .clk(fast_clk), //
    .data(ALUResult[31:16]),    //
    .seg(seg),
    .an(an)
);

// Map lower 16 bits of memory counter to LEDs
//assign LEDs[15:0] = counter_data[15:0];
assign LEDs[15:0] = ALUResult[15:0];
//ALUResult[31:16] - seven segment
//counter_data[31:16]
//wire any_branch_taken = (Branch & zero) | (Branch & BLT_taken & ALUResult[31]);
//assign dp = ~any_branch_taken; 
assign dp = ~(JAL | BLT_taken); // for task3
endmodule
