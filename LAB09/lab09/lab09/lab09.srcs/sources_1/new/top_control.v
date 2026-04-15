`timescale 1ns/1ps

module top(
    input clk,
    input rst,
    input btn,
    input [15:0] sw,
    output [15:0] led
);
    wire btn_pulse;

    // Instantiate the debouncer
    button_debouncer u_debouncer (
        .clk(clk),
        .rst(rst),
        .btn_in(btn),
        .btn_out_pulse(btn_pulse)
    );
    
    wire [31:0] switches_out;
    switches u_sw(
        .clk(clk),
        .rst(rst),
        .btns({15'b0, btn}),       
        .writeData(32'b0),         
        .writeEnable(1'b0),        
        .readEnable(1'b1),         
        .memAddress(30'b0),        
        .switches(sw),             
        .readData(switches_out)    
    );

    // FSM states
    localparam IDLE          = 2'd0,
               READ_SWITCHES = 2'd1,
               COMPUTE       = 2'd2,
               WRITE_LED     = 2'd3;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        if (btn_pulse) begin
            case (state)
                IDLE: next_state = READ_SWITCHES;
                READ_SWITCHES: next_state = COMPUTE;
                COMPUTE: next_state = WRITE_LED;
                WRITE_LED: next_state = IDLE;
                default: next_state = IDLE;
            endcase
        end
    end

    // switchs
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg funct7; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            opcode <= 7'b0;
            funct3 <= 3'b0;
            funct7 <= 1'b0;
        end else if (state == READ_SWITCHES) begin
            opcode <= switches_out[15:9];
            funct3 <= switches_out[8:6];
            funct7 <= switches_out[5]; 
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

    // LED
    reg [15:0] led_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) led_reg <= 16'b0;
        else if (state == WRITE_LED)
            led_reg <= {RegWrite, ALUSrc, MemRead, MemWrite,
                        MemtoReg, Branch, ALUOp, 4'b0, ALUControl};
    end

    
    wire [15:0] leds_out; 
    
    leds u_leds(
        .clk(clk),
        .rst(rst),
        .writeData({16'b0, led_reg}),     
        .writeEnable(state == WRITE_LED), 
        .readEnable(1'b0),                
        .memAddress(30'b0),               
        .readData(),                      
        .leds(leds_out)                   
    );

    assign led = leds_out;

endmodule