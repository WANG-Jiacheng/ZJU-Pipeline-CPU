`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/15 21:19:08
// Design Name: 
// Module Name: ImmGen
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

//这个模块详情可以见《数字逻辑与计算机组成》的page221，总之，这个immgen模块是完备的
module ImmGen(
input [31:0] imm_input,
input [2:0]is_csr,
output [31:0] imm_output
    );
reg [31:0] imm;
always @(*) begin
if(is_csr != 0)begin
imm <= 0;
end
else if(is_csr == 0)begin
case(imm_input[6:0])
7'b0010011: 
imm <= {{20{imm_input[31]}} , imm_input[31:20]};//immI
7'b0110111:
imm <= {imm_input[31:12], 12'b0};//immU
7'b1101111:
imm <= {{12{imm_input[31]}}, imm_input[19:12], imm_input[20], imm_input[30:21],1'b0};//immJ
7'b1100011:
imm <= {{20{imm_input[31]}}, imm_input[7], imm_input[30:25], imm_input[11:8],1'b0};//immB
7'b0000011:
imm <= {{20{imm_input[31]}} , imm_input[31:20]};//immI
7'b0100011:
imm <= {{20{imm_input[31]}} , imm_input[31:25] ,imm_input[11:7]};//immS
7'b0010111:
imm <= {imm_input[31:12], 12'b0}; //auipc
endcase
end
end
assign imm_output = imm;
 
endmodule