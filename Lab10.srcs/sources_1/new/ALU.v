`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/15 21:13:47
// Design Name: 
// Module Name: ALU
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


module ALU (
input [31:0] a,
input [31:0] b,//�˴���b�Ѿ��ɶ�·ѡ����ѡ����ǼĴ���rs2����������imm�ˣ��������alu�Ѿ��������걸��
input [3:0] alu_op,//����alu�Ĳ�����
input b_type ,//��ʾbeq/bnqִ�еľ������Σ�1'b0����bnq��1'b1����beq
output reg [31:0] res,
output zero//�����־λ
);
`include "AluOp.vh"//ȥ����ļ���飬���Բ鵽Ҫ�õ�ָ��opcode
reg flag;//flag���ջᱻ��ֵ��zero�������־���λ���Ծ���pc����һ��״̬��pc+4����һ����ת��ַ
always @(*)
case (alu_op)
ADD: res = a + b;
// TODO:
SUB:begin res = a - b;
if(res == 0 && b_type == 0)begin
    flag = 0;
end
else if(res == 0 && b_type == 1)begin
    flag = 1;
end
else if(res != 0 && b_type == 0)begin
    flag = 1;
end
else if(res != 0 && b_type == 1)begin
    flag = 0;
end
else if(res < 0 && b_type == 7)begin
    flag = 0;
end
else if(res >= 0 && b_type == 7)begin
    flag = 1;
end
end
SLT:begin
if(a[31]==1&&b[31]==0)begin
   res = 1;
end
else if(a[31]==0&&b[31]==1)begin
   res = 0;
end
else if(a[31]==0&&b[31]==0&&a<b)begin
  res = 1;
end
else if(a[31]==1&&b[31]==1&&a<b)begin
  res = 1;
end
end
OR: res = a | b;
SRL: res = a >> (b[4:0]); 
AND: res = a & b;
SLL: res = (a << b[4:0]);
default: res = 0;
endcase
assign zero = flag;
endmodule