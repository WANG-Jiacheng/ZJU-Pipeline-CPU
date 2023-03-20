`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/15 21:20:56
// Design Name: 
// Module Name: MUX4T1_32
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


module MUX4T1_32(
input [31:0]I0,
input [31:0]I1,
input [31:0]I2,
input [31:0]I3,
input [1:0]s,
output [31:0]o
);
reg [31:0]out;
always@(*)begin
    case (s)
    2'b00: out = I0;
    2'b01: out = I1;
    2'b10: out = I2 + 4;//cur_pc+4
    2'b11: out = I3;
    endcase
end
assign o = out;

endmodule