`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 15:11:21
// Design Name: 
// Module Name: SCPU
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


module SCPU(
    input         clk,
    input         rst,
    input  [31:0] inst,
    input  [31:0] data_in,  // data from data memory
    output [31:0] addr_out, // data memory address
    output [31:0] data_out, // data to data memory
    output [31:0] pc_out,   // connect to instruction memory
    output        mem_write,
    output [31:0]out,
    output [6:0]exmem_opcode,
    input cache_resp_stall
    );
    wire [3:0] alu_op;
    wire [1:0] pc_src, mem_to_reg;
    wire reg_write, alu_src, branch;
    wire [2:0]b_type;
    wire [31:0]out_1;
    wire mem_write_1;
    wire lui_flag;
    wire [2:0] csr_flag;
    wire auipc_flag;
    wire mret_flag;
    wire [1:0]csr_addr;
    
    wire [31:0]jump_pc;
    wire jump_flag;
    reg [2:0]stall_counter;
    reg [1:0]load_use_counter;
    reg stall_flag;
    reg load_use_flag;
    
    reg [31:0]pc;
    reg [31:0] IFID_inst;
    reg [31:0] IFID_pc;
    
    reg cache_stall_flag;
    
    always @(posedge clk)begin
       if(cache_resp_stall)begin  //�����cache��ͣ������inst��pc
       IFID_inst <= IFID_inst;
       IFID_pc <= IFID_pc;
       end
       else if((pc_src == 2'b01 || pc_src == 2'b10 || stall_flag == 1) && stall_counter <= 3)begin
       IFID_inst <= 32'h00000013;
       IFID_pc <= IFID_pc;
       stall_counter <= stall_counter + 1;
       stall_flag <= 1;
       end
       else if((IFID_inst[6:0] == 7'b0000011|| load_use_flag == 1) && load_use_counter <= 1)begin  //����load-useð��
       IFID_inst <= 32'h00000013;
       IFID_pc <= IFID_pc;
       load_use_flag <= 1;
       load_use_counter <= load_use_counter + 1;
       end
//       else if(cache_resp_stall)begin  //�����cache��ͣ������inst��pc
//       IFID_inst <= IFID_inst;
//       IFID_pc <= IFID_pc;
//       end
       else begin
       IFID_inst <= inst;
       IFID_pc <= pc;
       stall_counter <= 0;
       stall_flag <= 0;
       load_use_flag <= 0;
       load_use_counter <= 0;
       end
    end
    
    always @(posedge clk or posedge rst)begin
       if(rst) pc <= 32'b0;
       else if(cache_resp_stall)begin
       pc <= pc;
       end
       else if((jump_flag == 1'b0 && stall_counter < 3 && stall_counter != 0))begin
         pc <= pc;
       end
       else if((jump_flag == 1'b0 && stall_counter == 3)|| (jump_flag == 1'b0 && load_use_counter == 1))begin
         pc <= pc - 4;
       end
       else if(jump_flag == 1'b0 || stall_flag == 0)begin
         pc <= pc + 4;
       end
       else if(jump_flag == 1'b1)begin
         pc <= jump_pc;
       end  
    end
    assign pc_out = pc;
    
//    reg [31:0] IFID_inst;
//    reg [31:0] IFID_pc;
//    always @(posedge clk or posedge rst)begin
//       IFID_inst <= inst;
//       IFID_pc <= pc;
//    end
    
    Control control ( 
        .op_code(IFID_inst[6:0]),
        .funct3(IFID_inst[14:12]),
        .funct7_5(IFID_inst[30]),
        .pc_src(pc_src),         // 2'b00 ��ʾpc����������pc+4, 2'b01 ��ʾ��������JALR��ת��ַ, 2'b10��ʾ��������JAL��ת��ַ(����branch). branch ��ת������������
        .reg_write(reg_write),   // 1'b1 ��ʾд�Ĵ���
        .alu_src_b(alu_src_b),   // 1'b1 ��ʾALU B�ڵ�����Դ����imm, 1'b0��ʾ��������Reg[rs2]
        .alu_op(alu_op),         // ��������ALU�����������뿴AluOp.vh�жԸ��������ı���
        .mem_to_reg(mem_to_reg), // 2'b00 ��ʾд��rd����������ALU, 2'b01��ʾ��������imm, 2'b10��ʾ��������pc+4, 2'b11 ��ʾ��������data memory
        .mem_write(mem_write_1),   // 1'b1 ��ʾдdata memory, 1'b0��ʾ��data memory
        .branch(branch),         // 1'b1 ��ʾ��branch���͵�ָ��
        .b_type(b_type),          // 1'b1 ��ʾbeq, 1'b0 ��ʾbne
        .lui_flag(lui_flag),
        .csr_flag(csr_flag),
        .auipc_flag(auipc_flag),
        .mret_flag(mret_flag),
        .ecall_or_mret(IFID_inst[31:25]),
        .csr_addr(csr_addr),
        .inst(IFID_inst)
    );

    Datapath datapath (
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .reg_write(reg_write),
        .alu_src_b(alu_src_b),
        .branch(branch),
        .b_type(b_type),
        .alu_op(alu_op),
        .mem_to_reg(mem_to_reg),
        .inst_in(IFID_inst[31:0]),
        .data_in(data_in[31:0]),
        .addr_out(addr_out[31:0]),
        .data_out(data_out[31:0]),
        .pc(IFID_pc),
        .mem_write_1(mem_write_1),
        .lui_flag(lui_flag),
        //������
        .auipc_flag(auipc_flag),
        .csr_flag(csr_flag),
        .mret_flag(mret_flag),
        //�����������
        .exmem_write(mem_write),
//        .pc_out(pc_out[31:0]),
        .jump_flag(jump_flag),
        .jump_pc(jump_pc),
        .out(out_1),
        .csr_addr(csr_addr),
        
        //cache����
        .exmem_opcode(exmem_opcode),
        .cache_resp_stall(cache_resp_stall)
    );
    assign out = out_1;
endmodule
