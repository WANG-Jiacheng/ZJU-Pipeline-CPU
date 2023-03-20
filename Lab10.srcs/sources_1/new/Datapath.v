`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/15 21:11:29
// Design Name: 
// Module Name: DataPath
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

module Datapath(
    input         clk,
    input         rst,
    input  [31:0] inst_in,
    input  [31:0] data_in,
    input  [3:0] alu_op,
    input  [1:0] pc_src, 
    input  [1:0] mem_to_reg,
    input    reg_write, 
    input      alu_src_b, 
    input       branch,
    input   [2:0]  b_type,  
    input mem_write_1,
    input lui_flag,
    input [1:0]csr_addr,
    
    input [31:0]pc,
    
    input [2:0] csr_flag,
    input auipc_flag,
    input mret_flag,
    
    input cache_resp_stall,
    
    
    output reg exmem_write,
    output reg[31:0] addr_out, 
    output reg[31:0] data_out, 
//    output [31:0] pc_out,
    output [31:0] out,
    output reg[31:0] jump_pc,
    output reg jump_flag,
    output reg [6:0] exmem_opcode
    );
wire [31:0] mux_alu_out,read_data_1_out,mux4_out,imm_out;
wire[31:0]next_pc,cur_pc,out_1;
wire zero;
wire flag_j;
wire [1:0]ForwardA;
wire [1:0]ForwardB;
wire [31:0]resultA;
wire [31:0]resultB;
wire [31:0]addr_out_1;
wire [31:0]data_out_1;
wire ls;
//declare the register
//IDEX
reg [31:0]IDEX_Data1;
reg [31:0]IDEX_Data2;
reg [31:0]IDEX_imm_out;
reg [31:0]IDEX_Inst;
reg [31:0]IDEX_PC;
reg [31:0]IDEX_data_in;
reg [3:0]IDEX_alu_op;
reg [1:0]IDEX_pc_src;
reg [1:0]IDEX_mem_to_reg;
reg IDEX_reg_write;
reg IDEX_alu_src_b;
reg IDEX_branch;
reg [2:0]IDEX_b_type;
reg IDEX_mem_write;
reg IDEX_lui_flag;
//newadd
reg [2:0] IDEX_csr_flag;
reg IDEX_auipc_flag;

reg [31:0] IDEX_data_out_1;
reg IDEX_mret_flag;
reg [1:0] IDEX_csr_addr;

//EXMEM
reg [31:0]ALU_RESULT;
reg EXMEM_zero;
reg [31:0]EXMEM_imm_out;
reg [31:0]EXMEM_Inst;
reg [31:0]EXMEM_PC;
reg [31:0]EXMEM_data_in;
reg [3:0]EXMEM_alu_op;
reg [1:0]EXMEM_pc_src;
reg [1:0]EXMEM_mem_to_reg;
reg EXMEM_reg_write;
reg EXMEM_alu_src_b;
reg EXMEM_branch;
reg [2:0]EXMEM_b_type;
reg EXMEM_mem_write;
reg EXMEM_lui_flag;
//newadd
reg [2:0] EXMEM_csr_flag;
reg EXMEM_auipc_flag;

reg [31:0]EXMEM_data_out_1;
reg EXMEM_mret_flag;
reg [1:0] EXMEM_csr_addr;

//MEMWB
reg [31:0]MEMWB_Rd;
reg [31:0]MEMWB_imm_out;
reg [31:0]MEMWB_Inst;
reg [31:0]MEMWB_PC;
reg [31:0]MEMWB_data_in;
reg [3:0]MEMWB_alu_op;
reg [1:0]MEMWB_pc_src;
reg [1:0]MEMWB_mem_to_reg;
reg MEMWB_reg_write;
reg MEMWB_alu_src_b;
reg MEMWB_branch;
reg [2:0]MEMWB_b_type;

reg [2:0]MEMWB_csr_flag;
reg MEMWB_mret_flag;
reg [1:0] MEMWB_csr_addr;

reg [31:0]AfterMEMWB_Inst;
reg [31:0]After_mux_out;

always @(posedge clk)begin
//  if(ForwardA == 2'b10)begin
//  IDEX_Data1 <= ALU_RESULT;
//  end
//  else if(ForwardA == 2'b01)begin
//  IDEX_Data1 <= MEMWB_Rd;
//  end
//  else begin
//  IDEX_Data1 <= read_data_1_out;
//  end
//  if(ForwardB == 2'b10)begin
//  IDEX_Data2 <= ALU_RESULT;
//  end
//  else if(ForwardB == 2'b01)begin
//  IDEX_Data2 <= MEMWB_Rd;
//  end
//  else begin
//  IDEX_Data2 <= mux_alu_out;
//  end
if (rst) begin
  IDEX_Data1 <=0;
  IDEX_Data2 <= 0;
  IDEX_imm_out <= 0;
  IDEX_Inst <= 0;
  IDEX_PC <= 0;
  IDEX_data_in <= 0;
  IDEX_alu_op <= 0;
  IDEX_pc_src <= 0;
  IDEX_mem_to_reg <= 0;
  IDEX_reg_write <= 0;
  IDEX_alu_src_b <= 0;
  IDEX_branch <= 0;
  IDEX_b_type <= 0;
  IDEX_mem_write <= 0;
  IDEX_lui_flag <= 0;
  IDEX_csr_flag <= 0;
  IDEX_auipc_flag <= 0;
  IDEX_data_out_1 <= 0;
  IDEX_mret_flag <= 0;
  IDEX_csr_addr <= 0;
end
else if(cache_resp_stall)begin
  IDEX_Data1 <= IDEX_Data1;
  IDEX_Data2 <= IDEX_Data2;
  IDEX_imm_out <= IDEX_imm_out;
  IDEX_Inst <= IDEX_Inst;
  IDEX_PC <= IDEX_PC;
  IDEX_data_in <= IDEX_data_in;
  IDEX_alu_op <= IDEX_alu_op;
  IDEX_pc_src <= IDEX_pc_src;
  IDEX_mem_to_reg <= IDEX_mem_to_reg;
  IDEX_reg_write <= IDEX_reg_write;
  IDEX_alu_src_b <= IDEX_alu_src_b;
  IDEX_branch <= IDEX_branch;
  IDEX_b_type <= IDEX_b_type;
  IDEX_mem_write <= IDEX_mem_write;
  IDEX_lui_flag <= IDEX_lui_flag;
  IDEX_csr_flag <= IDEX_csr_flag;
  IDEX_auipc_flag <= IDEX_auipc_flag;
  IDEX_data_out_1 <= IDEX_data_out_1;
  IDEX_mret_flag <= IDEX_mret_flag;
  IDEX_csr_addr <= IDEX_csr_addr;
end
else begin
  IDEX_Data1 <= read_data_1_out;
  IDEX_Data2 <= mux_alu_out;
  IDEX_imm_out <= imm_out;
  IDEX_Inst <= inst_in;
  IDEX_PC <= pc;
  IDEX_data_in <= data_in;
  IDEX_alu_op <= alu_op;
  IDEX_pc_src <= pc_src;
  IDEX_mem_to_reg <= mem_to_reg;
  IDEX_reg_write <= reg_write;
  IDEX_alu_src_b <= alu_src_b;
  IDEX_branch <= branch;
  IDEX_b_type <= b_type;
  IDEX_mem_write <= mem_write_1;
  IDEX_lui_flag <= lui_flag;
  IDEX_csr_flag <= csr_flag;
  IDEX_auipc_flag <= auipc_flag;
  IDEX_data_out_1 <= data_out_1;
  IDEX_mret_flag <= mret_flag;
  IDEX_csr_addr <= csr_addr;
end
end

//reg [31:0]ALU_RESULT;
//reg EXMEM_zero;
//reg [31:0]EXMEM_imm_out;
//reg [31:0]EXMEM_Inst;
//reg [31:0]EXMEM_PC;
//reg [31:0]EXMEM_data_in;
//reg [3:0]EXMEM_alu_op;
//reg [1:0]EXMEM_pc_src;
//reg [1:0]EXMEM_mem_to_reg;
//reg EXMEM_reg_write;
//reg EXMEM_alu_src_b;
//reg EXMEM_branch;
//reg EXMEM_b_type;
always @(posedge clk)begin
if(rst)begin
  ALU_RESULT <= 0;
  addr_out <= 0;
  EXMEM_zero <= 0;
  EXMEM_imm_out <= 0;
  EXMEM_Inst <= 0;
  EXMEM_PC <= 0;
  EXMEM_data_in <= 0;
  EXMEM_alu_op <= 0;
  EXMEM_pc_src <= 0;
  EXMEM_mem_to_reg <= 0;
  EXMEM_reg_write <= 0;
  EXMEM_alu_src_b <= 0;
  EXMEM_branch <= 0;
  EXMEM_b_type <= 0;
  exmem_write <= 0;
  EXMEM_lui_flag <= 0;
  EXMEM_csr_flag <= 0;
  EXMEM_auipc_flag <= 0;
  EXMEM_data_out_1 <= 0;
  EXMEM_mret_flag <= 0;
  EXMEM_csr_addr <= 0;
end
else if(cache_resp_stall)begin
  ALU_RESULT <= ALU_RESULT;
  addr_out <= addr_out;
  EXMEM_zero <=EXMEM_zero;
  EXMEM_imm_out <= EXMEM_imm_out;
  EXMEM_Inst <= EXMEM_Inst;
  EXMEM_PC <= EXMEM_PC;
  EXMEM_data_in <= EXMEM_data_in;
  EXMEM_alu_op <= EXMEM_alu_op;
  EXMEM_pc_src <= EXMEM_pc_src;
  EXMEM_mem_to_reg <= EXMEM_mem_to_reg;
  EXMEM_reg_write <= EXMEM_reg_write;
  EXMEM_alu_src_b <= EXMEM_alu_src_b;
  EXMEM_branch <= EXMEM_branch;
  EXMEM_b_type <=  EXMEM_b_type;
  exmem_write <= exmem_write;
  EXMEM_lui_flag <= EXMEM_lui_flag;
  EXMEM_csr_flag <= EXMEM_csr_flag;
  EXMEM_auipc_flag <=EXMEM_auipc_flag;
  EXMEM_mret_flag <= EXMEM_mret_flag;
  EXMEM_csr_addr <=  EXMEM_csr_addr;
  
  exmem_opcode <= exmem_opcode;
  EXMEM_data_out_1 <= EXMEM_data_out_1;
end
else begin
  if(IDEX_lui_flag == 0)begin
  ALU_RESULT <= addr_out_1;
  end
  else if(IDEX_lui_flag == 1)begin
  ALU_RESULT <= IDEX_imm_out;
  end
  addr_out <= addr_out_1;
  EXMEM_zero <= zero;
  EXMEM_imm_out <= IDEX_imm_out;
  EXMEM_Inst <= IDEX_Inst;
  EXMEM_PC <= IDEX_PC;
  EXMEM_data_in <= IDEX_data_in;
  EXMEM_alu_op <= IDEX_alu_op;
  EXMEM_pc_src <= IDEX_pc_src;
  EXMEM_mem_to_reg <= IDEX_mem_to_reg;
  EXMEM_reg_write <= IDEX_reg_write;
  EXMEM_alu_src_b <= IDEX_alu_src_b;
  EXMEM_branch <= IDEX_branch;
  EXMEM_b_type <= IDEX_b_type;
  exmem_write <= IDEX_mem_write;
  EXMEM_lui_flag <= IDEX_lui_flag;
  EXMEM_csr_flag <= IDEX_csr_flag;
  EXMEM_auipc_flag <= IDEX_auipc_flag;
  EXMEM_mret_flag <= IDEX_mret_flag;
  EXMEM_csr_addr <= IDEX_csr_addr;
  
  exmem_opcode <= IDEX_Inst[6:0];
  
  if(ls == 0)begin
  EXMEM_data_out_1 <= IDEX_data_out_1;
  end
  else if(ls == 1)begin
  EXMEM_data_out_1 <= ALU_RESULT;
  end
end
end

//reg [31:0]MEMWB_Rd;
//reg [31:0]MEMWB_imm_out;
//reg [31:0]MEMWB_Inst;
//reg [31:0]MEMWB_PC;
//reg [31:0]MEMWB_data_in;
//reg [3:0]MEMWB_alu_op;
//reg [1:0]MEMWB_pc_src;
//reg [1:0]MEMWB_mem_to_reg;
//reg MEMWB_reg_write;
//reg MEMWB_alu_src_b;
//reg MEMWB_branch;
//reg MEMWB_b_type;
always @(posedge clk)begin
   if(rst)begin
   MEMWB_Rd <= 0;
   MEMWB_imm_out <= 0;
   MEMWB_Inst <= 0;
   MEMWB_PC <= 0;
   MEMWB_data_in <= 0;
   MEMWB_alu_op <= 0;
   MEMWB_pc_src <= 0;
   MEMWB_mem_to_reg <=0;
   MEMWB_reg_write <= 0;
   MEMWB_alu_src_b <= 0;
   MEMWB_branch <= 0;
   MEMWB_b_type <= 0;
   MEMWB_csr_flag <= 0;
   MEMWB_mret_flag <= 0;
   MEMWB_csr_addr <= 0;
   end
   
   else if(cache_resp_stall)begin
   MEMWB_Rd <= MEMWB_Rd;
   MEMWB_imm_out <= MEMWB_imm_out;
   MEMWB_Inst <= MEMWB_Inst;
   MEMWB_PC <= MEMWB_PC;
   MEMWB_data_in <= MEMWB_data_in;
   MEMWB_alu_op <= MEMWB_alu_op;
   MEMWB_pc_src <= MEMWB_pc_src;
   MEMWB_mem_to_reg <= MEMWB_mem_to_reg;
   MEMWB_reg_write <= MEMWB_reg_write;
   MEMWB_alu_src_b <= MEMWB_alu_src_b;
   MEMWB_branch <= MEMWB_branch;
   MEMWB_b_type <= MEMWB_b_type;
   MEMWB_csr_flag <= MEMWB_csr_flag;
   MEMWB_mret_flag <= MEMWB_mret_flag;
   MEMWB_csr_addr <= MEMWB_csr_addr;
   end
   
   
   else begin
//   if(EXMEM_lui_flag == 0)begin
   MEMWB_Rd <= ALU_RESULT;
//   end
//   else if(EXMEM_lui_flag == 1)begin
//   MEMWB_Rd <= EXMEM_imm_out;
//   end
//   addr_out <= ALU_RESULT;
   MEMWB_imm_out <= EXMEM_imm_out;
   MEMWB_Inst <= EXMEM_Inst;
   MEMWB_PC <= EXMEM_PC;
   MEMWB_data_in <= EXMEM_data_in;
   MEMWB_alu_op <= EXMEM_alu_op;
   MEMWB_pc_src <= EXMEM_pc_src;
   MEMWB_mem_to_reg <= EXMEM_mem_to_reg;
   MEMWB_reg_write <= EXMEM_reg_write;
   MEMWB_alu_src_b <= EXMEM_alu_src_b;
   MEMWB_branch <= EXMEM_branch;
   MEMWB_b_type <= EXMEM_b_type;
   MEMWB_csr_flag <= EXMEM_csr_flag;
   MEMWB_mret_flag <= EXMEM_mret_flag;
   MEMWB_csr_addr <= EXMEM_csr_addr;
//   exmem_write <= EXMEM_mem_write;
end
end

always@(posedge clk)begin
    if(rst)begin
        AfterMEMWB_Inst <= 0;
        After_mux_out <= 0;
    end
    else begin
        AfterMEMWB_Inst <= MEMWB_Inst;
        After_mux_out <= mux4_out;
    end
end


ALU alu(
.a(resultA),
.b(resultB),
.alu_op(IDEX_alu_op),
.b_type(IDEX_b_type),
.res(addr_out_1),
.zero(zero)
);

MUX2T1_32 mux_alu(
.I0(data_out_1),
.I1(imm_out),
.s(alu_src_b),
.o(mux_alu_out)
);

//pc_reg pc_reg(
//.clk(clk),
//.rst(rst),
//.next_pc(next_pc),
//.cur_pc(cur_pc)
//);

ImmGen immgen(
.imm_input(inst_in[31:0]),
.is_csr(csr_flag),
.imm_output(imm_out)
);

next_pc next_pc1(
.pc_src(EXMEM_pc_src),
.pc(EXMEM_PC),
.we(EXMEM_reg_write),//新添的 2021.9.26
.imm(EXMEM_imm_out),
.alu_result(ALU_RESULT),
.next_pc(next_pc),
.flag_j(flag_j),
.zero(EXMEM_zero)
);

Regs regs(
.clk(clk),
.rst(rst),
.we(MEMWB_reg_write),
.read_addr_1(inst_in[19:15]),
.read_addr_2(inst_in[24:20]),

.csr_flag_read(csr_flag),
.auipc_flag(auipc_flag),
.mret_flag(mret_flag),
.mret_flag_write(MEMWB_mret_flag),
.pc_input_aui(pc),
.pc_input(MEMWB_PC),
.CSRREG_read(inst_in[31:20]),
.CSRREG_write(MEMWB_csr_addr/*MEMWB_Inst[31:20]*/),
.csr_flag_write(MEMWB_csr_flag),

.write_addr(MEMWB_Inst[11:7]),
.csr_write_addr(inst_in[11:7]),
.write_data(mux4_out),
.read_data_1(read_data_1_out),
.read_data_2(data_out_1),
.out(out_1)
);

MUX4T1_32 mux(
.I0(MEMWB_Rd),
.I1(MEMWB_imm_out),
.I2(MEMWB_PC),//这里也许会有pc的问题，记得改，pc模块可能都有问题
.I3(IDEX_data_in),
.s(MEMWB_mem_to_reg),
.o(mux4_out)
);

ForwardingUnit forwardingunit(
.id_ex_rs1(IDEX_Inst[19:15]),
.id_ex_rs2(IDEX_Inst[24:20]),
.ex_mem_rd(EXMEM_Inst[11:7]),
.mem_wb_rd(MEMWB_Inst[11:7]),
.alu_src_b(IDEX_alu_src_b),
.ex_mem_csr(EXMEM_Inst[31:20]),
.mret_flag(IDEX_mret_flag),
.opcode(IDEX_Inst[6:0]),
.ex_mem_regwrite(EXMEM_reg_write),
.mem_wb_regwrite(MEMWB_reg_write),
.ForwardA(ForwardA),
.ForwardB(ForwardB),
.ls(ls)
);

MUX3T1_A mux3t1_a(
.ForwardA(ForwardA),
.IDEX_Data1(IDEX_Data1),
.EXMEM_Rd(ALU_RESULT),
.MEMWB_Rd(MEMWB_Rd),
.is_auipc(IDEX_auipc_flag),
.resultA(resultA)
);

MUX3T1_B mux3t1_b(
.ForwardB(ForwardB),
.IDEX_Data2(IDEX_Data2),
.EXMEM_Rd(ALU_RESULT),
.MEMWB_Rd(MEMWB_Rd),
.resultB(resultB),
.ls(ls)
);

//assign pc_out = cur_pc;
always @(posedge clk)begin
  if(flag_j == 1'b1)begin
  jump_pc <= next_pc;
  jump_flag <= 1'b1;
  end
  else if(flag_j == 1'b0)begin
  jump_flag <= 1'b0;
  end
end
assign out = out_1;

always@(*)begin
  if(EXMEM_Inst[24:20] == AfterMEMWB_Inst[11:7]/*EXMEM_Inst[24:20] == MEMWB_Inst[11:7]*/)begin
     data_out = After_mux_out;
  end
  else begin
     data_out = EXMEM_data_out_1;//data_out = data_out_1;
  end
end
endmodule
