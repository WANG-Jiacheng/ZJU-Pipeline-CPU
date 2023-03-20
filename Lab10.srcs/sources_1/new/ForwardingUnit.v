`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/09 11:28:36
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
    input [4:0]id_ex_rs1,
    input [4:0]id_ex_rs2,
    input [4:0]ex_mem_rd,
    input [4:0]mem_wb_rd,
    input [11:0] ex_mem_csr,
    input mret_flag,
    input alu_src_b,
    input ex_mem_regwrite,
    input mem_wb_regwrite,
    input [6:0]opcode,
    output reg [1:0]ForwardA,
    output reg [1:0]ForwardB,
    output reg ls
);
always@(*)begin
ls = 0;
if(ex_mem_csr == 12'b001101000001 && mret_flag)begin
    ForwardA = 2'b10;
    ForwardB = 2'b00;
end
else if(id_ex_rs1 == ex_mem_rd && id_ex_rs2 == ex_mem_rd)begin
  if(ex_mem_regwrite && ex_mem_rd != 0)begin
    ForwardA = 2'b10;
    if(alu_src_b == 1'b0)begin
      ForwardB = 2'b10;
    end
    else if(alu_src_b == 1'b1)begin
      ForwardB = 2'b00;
    end
  end
  else begin
    ForwardA = 2'b00;
    ForwardB = 2'b00;
  end
end
else if(id_ex_rs1 == ex_mem_rd && id_ex_rs2 != ex_mem_rd)begin
    if(ex_mem_regwrite && ex_mem_rd != 0)begin
      ForwardA = 2'b10;
    end
    else if(ex_mem_regwrite == 0 || ex_mem_rd == 0)begin
        ForwardA = 2'b00;
    end
    if(id_ex_rs2 == mem_wb_rd && mem_wb_regwrite && mem_wb_rd != 0)begin
      ForwardB = 2'b01;
    end
    if(id_ex_rs2 != mem_wb_rd || mem_wb_regwrite == 0 || mem_wb_rd == 0)begin
      ForwardB = 2'b00;
    end
end
else if(id_ex_rs1 != ex_mem_rd && id_ex_rs2 == ex_mem_rd)begin
    if(ex_mem_regwrite && ex_mem_rd != 0)begin
       if(alu_src_b == 1'b0)begin
          ForwardB = 2'b10;
       end
//       else if(alu_src_b == 1'b1)begin
//          ForwardB = 2'b00;
//       end
       else if(alu_src_b == 1'b1 && opcode != 7'b0100011)begin
          ForwardB = 2'b00;
       end
       else if(alu_src_b == 1'b1 && opcode == 7'b0100011)begin
          ForwardB = 2'b00;//ForwardB = 2'b10;
          ls = 1;
       end
    end
    else if(ex_mem_regwrite == 0 || ex_mem_rd == 0)begin
        ForwardB = 2'b00;
    end
    if(id_ex_rs1 == mem_wb_rd && mem_wb_regwrite && mem_wb_rd != 0)begin
      ForwardA = 2'b01;
    end
    if(id_ex_rs1 != mem_wb_rd || mem_wb_regwrite == 0 || mem_wb_rd == 0)begin
      ForwardA = 2'b00;
    end
end
else if(id_ex_rs1 != ex_mem_rd && id_ex_rs2 != ex_mem_rd)begin
    if(id_ex_rs1 == mem_wb_rd && id_ex_rs2 == mem_wb_rd && mem_wb_regwrite && mem_wb_rd != 0)begin
       ForwardA = 2'b01;
       if(alu_src_b == 1'b0)begin
          ForwardB = 2'b01;
       end
       else if(alu_src_b == 1'b1)begin
          ForwardB = 2'b00;
       end
    end
    else if(id_ex_rs1 == mem_wb_rd && id_ex_rs2 != mem_wb_rd && mem_wb_regwrite && mem_wb_rd != 0)begin
       ForwardA = 2'b01;
       ForwardB = 2'b00;
    end
    else if(id_ex_rs1 != mem_wb_rd && id_ex_rs2 == mem_wb_rd && mem_wb_regwrite && mem_wb_rd != 0)begin
       ForwardA = 2'b00;
       if(alu_src_b == 1'b0)begin
          ForwardB = 2'b01;
       end
       else if(alu_src_b == 1'b1)begin
          ForwardB = 2'b00;
       end
    end
    else if(id_ex_rs1 != mem_wb_rd && id_ex_rs2 != mem_wb_rd && mem_wb_regwrite && mem_wb_rd != 0)begin
      ForwardA = 2'b00;
      ForwardB = 2'b00;
    end
    else begin
      ForwardA = 2'b00;
      ForwardB = 2'b00;
    end
end
end      
endmodule
