`timescale 1ns/1ps

module RF_ALU_FSM_tb;

reg clk, rst;
reg WriteEnable;
reg [4:0] rs1, rs2, rd;
reg [31:0] WriteData;
reg [3:0] ALUControl;

wire [31:0] ReadData1, ReadData2;
wire [31:0] ALUResult;
wire Zero;

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

ALU alu(
    .A(ReadData1),
    .B(ReadData2),
    .ALU_control(ALUControl),
    .ALU_result(ALUResult),
    .Zero(Zero)
);

// clock
initial clk = 0;
always #5 clk = ~clk;


// FSM states
localparam [2:0]
    IDLE            = 3'd0,
    WRITE_REGS      = 3'd1,
    READ_REGISTERS  = 3'd2,
    ALU_OPERATION   = 3'd3,
    WRITE_RESULTS   = 3'd4,
    BEQ_CHECK       = 3'd5,
    WRITE_REGS2     = 3'd6;


reg [2:0] state;
reg [2:0] op_count;

reg [3:0] alu_ops [0:6];

initial begin
    alu_ops[0] = 4'b0010; // ADD
    alu_ops[1] = 4'b0110; // SUB
    alu_ops[2] = 4'b0000; // AND
    alu_ops[3] = 4'b0001; // OR
    alu_ops[4] = 4'b0011; // XOR
    alu_ops[5] = 4'b0100; // SLL
    alu_ops[6] = 4'b0101; // SRL
end


// reset and startup
initial begin
    rst = 1;
    WriteEnable = 0;
    WriteData = 0;
    rd = 0;
    rs1 = 0;
    rs2 = 0;
    ALUControl = 0;
    op_count = 0;
    state = IDLE;

    #20;
    rst = 0;
end


always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        WriteEnable <= 0;
        WriteData <= 0;
        rd <= 0;
        rs1 <= 0;
        rs2 <= 0;
        ALUControl <= 0;
        op_count <= 0;
    end
    else begin

        WriteEnable <= 0;

        case(state)

            IDLE: begin
                op_count <= 0;
                state <= WRITE_REGS;
            end

            WRITE_REGS: begin
                WriteEnable <= 1;

                case(op_count)
                    3'd0: begin rd <= 5'd1; WriteData <= 32'h10101010; end
                    3'd1: begin rd <= 5'd2; WriteData <= 32'h01010101; end
                    3'd2: begin rd <= 5'd3; WriteData <= 32'h00000005; end
                    default: begin rd <= 0; WriteData <= 0; end
                endcase

                if (op_count == 3'd2) begin
                    op_count <= 0;
                    state <= READ_REGISTERS;
                end
                else
                    op_count <= op_count + 1;
            end


            READ_REGISTERS: begin
                rs1 <= 5'd1;
                rs2 <= (op_count >= 3'd5) ? 5'd3 : 5'd2;
                ALUControl <= alu_ops[op_count];
                state <= ALU_OPERATION;
            end


            ALU_OPERATION: begin
                state <= WRITE_RESULTS;
            end


            WRITE_RESULTS: begin
                WriteEnable <= 1;
                rd <= 5'd4 + op_count;
                WriteData <= ALUResult;

                if (op_count == 3'd6) begin
                    op_count <= 0;
                    state <= BEQ_CHECK;
                end
                else begin
                    op_count <= op_count + 1;
                    state <= READ_REGISTERS;
                end
            end


            BEQ_CHECK: begin
                rs1 <= 5'd1;
                rs2 <= 5'd1;
                ALUControl <= 4'b0110; // SUB

                if (Zero) begin
                    WriteEnable <= 1;
                    rd <= 5'd11;
                    WriteData <= 32'h00000001;
                end

                state <= WRITE_REGS2;
            end


            WRITE_REGS2: begin
                WriteEnable <= 1;
                rd <= 5'd12;
                WriteData <= 32'hDEADBEEF;
                rs1 <= 5'd12;

                state <= IDLE;
                $finish;
            end


            default: state <= IDLE;

        endcase
    end
end

endmodule