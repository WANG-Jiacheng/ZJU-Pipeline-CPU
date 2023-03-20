`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/09 22:06:38
// Design Name: 
// Module Name: MUX3T1_B
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


module MUX3T1_B(
   input [1:0]ForwardB,
   input [31:0]IDEX_Data2,
   input [31:0]EXMEM_Rd,
   input [31:0]MEMWB_Rd,
   input ls,
   output reg[31:0] resultB
);
always@(*)begin
case(ForwardB)
   2'b10:resultB = EXMEM_Rd;
   2'b01: resultB = MEMWB_Rd;
   default: begin
   resultB = IDEX_Data2;
//   if(ls == 0)begin
//     resultB = IDEX_Data2;
//   end
//   else if(ls == 1)begin
//     resultB = EXMEM_Rd;
//   end
   end
endcase
end
endmodule
