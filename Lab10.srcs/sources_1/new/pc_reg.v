`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/15 21:18:19
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    input              clk,
    input              rst,
    input [31:0]       next_pc,
    output reg [31:0]  cur_pc
    );

    always @ (posedge clk or posedge rst) begin
        if(rst)
            cur_pc <= 32'b0;
        else
            cur_pc <= next_pc;
    end    
endmodule