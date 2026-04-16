`timescale 1ns/1ps

module top_rf_alu(
    input clk,
    input rst,
    input [3:0] alu_op_switch,
    input write_en_switch,
    input [4:0] rd_switch,
    output [7:0] leds
);

wire [31:0] ReadData1, ReadData2;
wire [31:0] ALUResult;
wire Zero;

reg [4:0] rs1, rs2, rd;
reg [31:0] WriteData;
reg WriteEnable;
reg [3:0] ALUControl;

reg [2:0] state;

localparam
    IDLE            = 3'd0,
    WRITE_REGS      = 3'd1,
    READ_REGISTERS  = 3'd2,
    ALU_OPERATION   = 3'd3,
    WRITE_RESULTS   = 3'd4;


// Register File
Register RF(
    .clk(clk),
    .rst(rst),
    .WriteEnable(WriteEnable),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .WriteData(WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);


// ALU
ALU alu(
    .A(ReadData1),
    .B(ReadData2),
    .ALU_control(ALUControl),
    .ALU_result(ALUResult),
    .Zero(Zero)
);


always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        rs1 <= 5'd0;
        rs2 <= 5'd0;
        rd <= 5'd0;
        WriteData <= 32'b0;
        WriteEnable <= 1'b0;
        ALUControl <= 4'b0;
    end
    else begin

        WriteEnable <= 1'b0;

        case(state)

            IDLE: begin
                state <= WRITE_REGS;
            end


            WRITE_REGS: begin
                WriteEnable <= 1'b1;
                rd <= 5'd1;
                WriteData <= 32'h10101010;
                state <= READ_REGISTERS;
            end


            READ_REGISTERS: begin
                WriteEnable <= 1'b1;
                rd <= 5'd2;
                WriteData <= 32'h01010101;

                rs1 <= 5'd1;
                rs2 <= 5'd2;

                ALUControl <= alu_op_switch;

                state <= ALU_OPERATION;
            end


            ALU_OPERATION: begin
                ALUControl <= alu_op_switch;
                state <= WRITE_RESULTS;
            end


            WRITE_RESULTS: begin
                WriteEnable <= write_en_switch;
                rd <= rd_switch;
                WriteData <= ALUResult;

                state <= ALU_OPERATION;
            end


            default: state <= IDLE;

        endcase
    end
end


assign leds = ALUResult[7:0];

endmodule
