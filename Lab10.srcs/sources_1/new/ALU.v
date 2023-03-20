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
input [31:0] b,//此处的b已经由多路选择器选择过是寄存器rs2还是立即数imm了，所以这个alu已经是输入完备的
input [3:0] alu_op,//输入alu的操作码
input b_type ,//表示beq/bnq执行的具体情形，1'b0就是bnq，1'b1就是beq
output reg [31:0] res,
output zero//结果标志位
);
`include "AluOp.vh"//去这个文件里查，可以查到要用的指令opcode
reg flag;//flag最终会被赋值给zero，这个标志输出位可以决定pc的下一个状态是pc+4还是一个跳转地址
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