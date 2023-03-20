`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/15 21:20:20
// Design Name: 
// Module Name: Regs
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


module Regs (
input clk,
input rst,
input we,
input [4:0] read_addr_1,
input [4:0] read_addr_2,

input [2:0] csr_flag_read,
input auipc_flag,
input [31:0] pc_input_aui,
input [31:0] pc_input,
input [11:0] CSRREG_read,
input [1:0] CSRREG_write,
input [2:0] csr_flag_write,
//input [31:0] inst_in,
//input [31:0] IDEX_inst,
//input [31:0] EXMEM_inst,
input [4:0]csr_write_addr,
input mret_flag,
input mret_flag_write,

input [4:0] write_addr,
input [31:0] write_data,
output reg[31:0] read_data_1,
output reg[31:0] read_data_2,
output [31:0] out
);

integer i;
reg [31:0] register [1:31]; // x1 - x31, x0 keeps zero
reg [31:0] mstatus;
reg [31:0] mtvec;
reg [31:0] mepc;
always @(negedge clk or posedge rst) begin
if (rst == 1)begin
for (i = 1; i < 32; i = i + 1) register[i] <= 0; // reset
//mstatus <= 0;
//mtvec <= 0;
//mepc <= 0;
end
else if (we == 1 && write_addr != 0)begin
register[write_addr] <= write_data;
end
end

always@(posedge clk)begin
if(csr_flag_write == 3'b001 && we == 1)begin
    if(CSRREG_write == 1/*12'b001100000000*/)begin //mstatus
//      if(write_addr != 0)begin
//        register[write_addr] <= mstatus;
//      end
      mstatus <= write_data;
    end
    else if(CSRREG_write == 2/*12'b001100000101*/)begin
//        if(write_addr != 0)begin
//            register[write_addr] <= mtvec;
//        end
        mtvec <= write_data;
    end
    else if(CSRREG_write == 3/*12'b001101000001*/)begin
        mepc <= write_data;
    end
end
else if(csr_flag_write == 3'b010 && we == 1)begin
    if(CSRREG_write == 3/*12'b001101000001*/)begin
//        if(write_addr != 0)begin
//            register[write_addr] <= mepc;
//        end
        mepc <= write_data;
    end
end
else if(csr_flag_write == 3'b100)begin
    if(mret_flag_write == 0)begin
        mepc <= pc_input + 4;
    end
end
end
//else if(we == 1)begin
//    if(csr_flag_write == 0 && write_addr != 0)begin
//        register[write_addr] = write_data;
//    end
//    else if(csr_flag_write != 0)begin
//        if(CSRREG == 12'b001100000000)begin //mstatus
//            if(write_addr != 0)begin
//                register[write_addr] = mstatus;
//            end
//            mstatus = write_data;
//       end
//    end
//end
assign out = register[20];
//assign read_data_1 = (read_addr_1 == 0) ? 0 : register[read_addr_1]; // read
//assign read_data_2 = (read_addr_2 == 0) ? 0 : register[read_addr_2]; // read
//assign read_data_1 = (auipc_flag == 0) ? ((read_addr_1 == 0) ? 0 : register[read_addr_1]) : pc_input;
//assign read_data_2 = (read_addr_2 == 0) ? 0 : register[read_addr_2];
always@(*)begin
if(auipc_flag == 0 && csr_flag_read == 0)begin
    if(read_addr_1 == 0)begin
        read_data_1 = 0;
    end
    else if(read_addr_1 > 0)begin
        read_data_1 = register[read_addr_1];
    end
end
else if(auipc_flag == 0 && csr_flag_read != 0)begin
    if(csr_flag_read == 3'b001)begin
       if(CSRREG_read == 12'b001100000000)begin //mstatus
            read_data_1 = register[read_addr_1];
            if(csr_write_addr)begin
               // register[csr_write_addr] = mstatus;
            end
       end
       else if(CSRREG_read == 12'b001100000101)begin
            read_data_1 = register[read_addr_1];
            if(csr_write_addr)begin
               // register[csr_write_addr] = mtvec;
            end
       end
       else if(CSRREG_read == 12'b001101000001)begin
            read_data_1 = register[read_addr_1];
            if(csr_write_addr)begin
                //register[csr_write_addr] = mepc;
            end
        end
    end
    else if(csr_flag_read == 3'b100)begin
        if(mret_flag == 0)begin
            read_data_1 = mtvec;
            //mepc = pc_input + 4;
        end
        else if(mret_flag == 1)begin
            read_data_1 = mepc;
        end
    end
    else if(csr_flag_read == 3'b010)begin
        if(CSRREG_read == 12'b001101000001)begin  //mepc
            read_data_1 = mepc | ((read_addr_1 == 0) ? 0 : register[read_addr_1]);
            if(csr_write_addr)begin
                //register[csr_write_addr] = mepc;
            end
        end
    end
end
else if(auipc_flag != 0)begin
    read_data_1 = pc_input_aui;
end
end

always@(*)begin
if(read_addr_2 == 0)begin
    read_data_2 = 0;
end
else if(read_addr_2 > 0)begin
    read_data_2 = register[read_addr_2];
end
end
endmodule
