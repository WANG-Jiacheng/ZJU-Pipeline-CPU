`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/15 21:15:52
// Design Name: 
// Module Name: MUX2T1_32
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

//�걸��
module MUX2T1_32(
input [31:0]I0,//R[rs2]
input [31:0]I1,//Imm
input s,//sΪ1'b1ѡ��Imm��Ϊ1'b0ѡ��R[rs2]
output [31:0]o
);
assign o = (s==0) ? I0 : I1;
endmodule