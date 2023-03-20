`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/16 17:01:17
// Design Name: 
// Module Name: mem_valid_counter
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


module mem_valid_counter(
    input rst,
    input [31:0]clk_div,
    input clk,
    output mem_valid,
    input en
);

wire [31:0] clk_div_next;
assign clk_div_next = clk_div + 1;

reg btn1,btn2; 
always @ (posedge rst or posedge clk)begin
    if(rst) begin
         btn1 <= 1'b0;
         btn2 <=1'b0;
     end
     else begin
         btn1 <= clk_div_next[3];
         btn2 <= btn1;
     end
end

assign mem_valid = (en) ? (btn1 & (~btn2)) : 0;
endmodule

