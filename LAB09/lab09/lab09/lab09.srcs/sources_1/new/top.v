`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2026 11:26:06 AM
// Design Name: 
// Module Name: top
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

module top(
    input clk,
    input rst,
    input btn_next,
    input [15:0] sw,
    output [15:0] led
);

    // 50 Hz tick generator (assuming 50 MHz clock)
    reg [19:0] slow_clk;
    reg tick_50hz;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            slow_clk <= 0;
            tick_50hz <= 0;
        end else begin
            if (slow_clk == 999_999) begin
                slow_clk <= 0;
                tick_50hz <= 1;
            end else begin
                slow_clk <= slow_clk + 1;
                tick_50hz <= 0;
            end
        end
    end
    
    
    // Sampling
    reg btn_sampled, btn_prev;
    wire btn_pulse;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_sampled <= 0;
            btn_prev <= 0;
        end else if (tick_50hz) begin
            btn_prev <= btn_sampled;
            btn_sampled <= btn_next;   // sample button at 50 Hz
        end
    end

    assign btn_pulse = btn_sampled & ~btn_prev;
    // switches module
    wire [31:0] switches_out;
    switches u_sw(
        .clk(clk),
        .rst(rst),
        .switches_in(sw),
        .switches_out(switches_out)
    );

    // FSM states
    localparam IDLE=2'd0,
               READ_SWITCHES=2'd1,
               COMPUTE=2'd2,
               WRITE_LED=2'd3;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst)
        if (rst) state<=IDLE;
        else state<=next_state;

    always @(*) begin
        next_state=state;
        if (btn_pulse) begin
            case (state)
                IDLE: next_state=READ_SWITCHES;
                READ_SWITCHES: next_state=COMPUTE;
                COMPUTE: next_state=WRITE_LED;
                WRITE_LED: next_state=IDLE;
                default: next_state=IDLE;
            endcase
        end
    end

    // switch capture
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg funct7;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            opcode<=7'b0;
            funct3<=3'b0;
            funct7<=0;
        end else if (state==READ_SWITCHES) begin
            opcode<=switches_out[15:9];
            funct3<=switches_out[8:6];
            funct7<=switches_out[5];
        end
    end

    // control outputs
    wire RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    MainControl u_mc(
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    ALUControl u_ac(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    // LED capture
    reg [15:0] led_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) led_reg<=16'b0;
        else if (state==WRITE_LED)
            led_reg<={RegWrite, ALUSrc, MemRead, MemWrite,
                      MemtoReg, Branch, ALUOp, 4'b0, ALUControl};
    end

    // leds module
    wire [31:0] leds_out;
    leds u_leds(
        .clk(clk),
        .rst(rst),
        .data_in({16'b0, led_reg}),
        .leds_out(leds_out)
    );

    assign led=leds_out[15:0];

endmodule