`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/15 21:19:45
// Design Name: 
// Module Name: next_pc
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

//完备的
module next_pc(
    input [1:0]     pc_src,
    input [31:0]    pc,
    input we,
    input [31:0]    imm,
    input [31:0] alu_result,
    input zero,
    output reg[31:0]    next_pc,
    output reg flag_j
    );

always @ (*) begin     
                          
        if((pc_src == 2'b10 && zero == 1) || (pc_src == 2'b10 && we == 1'b1))begin   //前一个表示跳转，且满足b型跳转；后一个表示跳转，且可以写寄存器（即jal）
            next_pc <= pc + imm;
            flag_j <= 1'b1;
            end
        else if(pc_src == 2'b01 && we == 1'b1)begin
            next_pc <= alu_result;
            flag_j <= 1'b1;
            end
        else if(pc_src == 2'b00 || zero == 0)begin
            flag_j <= 1'b0;//next_pc <= pc + 1'h1;
            end
end

endmodule

