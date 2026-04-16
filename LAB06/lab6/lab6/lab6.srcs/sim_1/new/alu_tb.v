`timescale 1ns / 1ps

module ALU_tb; 
reg [31:0] A; 
reg [31:0] B; 
reg [3:0] ALU_control; 
wire [31:0] ALU_result; 
wire Zero; 
ALU uut ( 
    .A(A), 
    .B(B), 
    .ALU_control(ALU_control), 
    .ALU_result(ALU_result), 
    .Zero(Zero) 
); 
initial begin 
A = 10; 
B = 5; 
ALU_control = 4'b0000; // AND 
#10; 
ALU_control = 4'b0001; // OR 
#10;
ALU_control = 4'b0010; // ADD 
#10; 
ALU_control = 4'b0110; // SUB 
#10; 
ALU_control = 4'b0011; // XOR 
#10; 
ALU_control = 4'b0100; // SLL 
#10; 
ALU_control = 4'b0101; // SRL 
#10; 
end 
endmodule 

 
