`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/09 22:06:38
// Design Name: 
// Module Name: MUX3T1_A
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


module MUX3T1_A(
   input [1:0]ForwardA,
   input [31:0]IDEX_Data1,
   input [31:0]EXMEM_Rd,
   input [31:0]MEMWB_Rd,
   input is_auipc,
   output reg [31:0]resultA
 );
 always@(*)begin
 case (ForwardA)
   2'b10: begin
   if(is_auipc == 0)begin
    resultA = EXMEM_Rd;
   end
   else if(is_auipc == 1)begin
    resultA = IDEX_Data1;
   end
   end
   2'b01: begin
   if(is_auipc == 0)begin
    resultA = MEMWB_Rd;
   end
   else if(is_auipc == 1)begin
    resultA = IDEX_Data1;
   end
   end
   default: resultA = IDEX_Data1;
 endcase
 end
endmodule
