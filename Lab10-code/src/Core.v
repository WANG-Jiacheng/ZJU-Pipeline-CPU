`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 18:08:36
// Design Name: 
// Module Name: Core
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


module Core(
    input  wire        clk,
    input  wire        aresetn,
    input  wire        step,
    input  wire        debug_mode,
    // input  wire [4:0]  debug_reg_addr, // register address

    output wire [31:0] address,
    output wire [31:0] data_out,
    input  wire [31:0] data_in,
    
    input  wire [31:0] chip_debug_in,
    output wire [31:0] chip_debug_out0,
    output wire [31:0] chip_debug_out1,
    output wire [31:0] chip_debug_out2,
    output wire [31:0] chip_debug_out3,
    output wire [31:0] chip_debug_out4
);
    wire rst, mem_write, mem_clk, cpu_clk;
    wire [31:0]out;
    wire [31:0] inst, core_data_in, addr_out, core_data_out, pc_out;
    reg  [31:0] clk_div;
//    reg [31:0] IFID_inst; //IF/ID�Ĵ�������inst��data to data memory
//    reg [31:0] IFID_core_data_in;
//    always @(*)begin
//      IFID_inst = 0;
//      IFID_core_data_in = 0;
//    end
    wire [31:0]mem_req_addr;
    wire [31:0]mem_req_data;
    wire mem_req_wen;
    wire mem_req_valid;
    wire [31:0]mem_resp_data;
    wire mem_resp_valid;
    wire cache_req_valid;
    wire [6:0]exmem_opcode;
    wire cache_resp_stall;
    wire [31:0]cache_out;
    
    wire[31:0]I_mem_req_addr;
    wire I_mem_req_valid;
    wire[31:0]I_mem_resp_data;
    wire I_mem_resp_valid;
    wire I_cache_resp_stall;
    
    wire cache_resp_stall_all;
    
    assign cache_resp_stall_all = cache_resp_stall | I_cache_resp_stall;
    
    assign rst = ~aresetn;
    SCPU cpu(
        .clk(cpu_clk),
        .rst(rst),
        .inst(inst),//.inst(IFID_inst),
        .data_in(core_data_in),//.data_in(IFID_core_data_in),      // data from data memory
        .addr_out(addr_out),         // data memory address
        .data_out(core_data_out),    // data to data memory
        .pc_out(pc_out),             // connect to instruction memory
        .mem_write(mem_write),
        .out(out),
        .exmem_opcode(exmem_opcode),
        .cache_resp_stall(cache_resp_stall_all)
    );
    
    always @(posedge clk) begin
        if(rst) clk_div <= 0;
        else clk_div <= clk_div + 1;
    end
    assign mem_clk = ~clk_div[0]; // 50mhz
    assign cpu_clk = debug_mode ? clk_div[0] : step;
    
     //TODO: 连接Instruction Memory
//    Rom rom_unit (
//        .a(pc_out[31:0] >> 2),  // 地址输入
//        .spo(inst[31:0]) // 读数据输�?
//    );
    
    // TODO: 连接Data Memory
   assign cache_req_valid = (exmem_opcode == 7'b0000011 || exmem_opcode == 7'b0100011) ? 1 : 0;
    D_cache Dcache(
        .clk(cpu_clk),
        .rst(rst),
        .cache_req_addr(addr_out[31:0]),
        .cache_req_data(core_data_out[31:0]),
        .cache_req_wen(mem_write),
        .cache_req_valid(cache_req_valid),
        .cache_resp_data(core_data_in[31:0]),
        .cache_resp_stall(cache_resp_stall),
        .mem_req_addr(mem_req_addr),
        .mem_req_data(mem_req_data),
        .mem_req_wen(mem_req_wen),
        .mem_req_valid(mem_req_valid),
        .mem_resp_data(mem_resp_data),
        .mem_resp_valid(mem_resp_valid),
        .cache_out(cache_out),
        .inst(inst[31:0])
        
    );
    
    I_cache Icache(
        .clk(cpu_clk),
        .rst(rst),
        .cache_req_addr(pc_out[31:0]),
        .cache_req_data(),
        .cache_req_wen(0),
        .cache_req_valid(1),
        .cache_resp_data(inst[31:0]),
        .cache_resp_stall(I_cache_resp_stall),
        .mem_req_addr(I_mem_req_addr),
        .mem_req_data(),
        .mem_req_wen(),
        .mem_req_valid(I_mem_req_valid),
        .mem_resp_data(I_mem_resp_data),
        .mem_resp_valid(I_mem_resp_valid)
    );
    
    LatencyMemory2 rom_unit(
        .clk(mem_clk),
        .we(0),
        .addr(I_mem_req_addr),
        .data_in(),
        .data_out(I_mem_resp_data),
        .mem_resp_valid(I_mem_resp_valid),
        .en(I_mem_req_valid)
    );
   
    LatencyMemory ram_unit(
        .clk(mem_clk),
        .we(mem_req_wen),
        .addr(mem_req_addr),
        .data_in(mem_req_data),
        .data_out(mem_resp_data),
        .mem_resp_valid(mem_resp_valid),
        .en(mem_req_valid)
    );
    
    
//    Ram ram_unit (
//        .clka(mem_clk),  // 时钟
//        .wea(mem_write),   // 是否写数�?
//        .addra(addr_out[31:0] >> 2), // 地址输入
//        .dina(core_data_out[31:0]),  // 写数据输�?
//        .douta(core_data_in[31:0])  // 读数据输�?
//    );
    
//    always @(posedge cpu_clk or posedge rst)begin
//           IFID_inst <= inst;
//           IFID_core_data_in <= core_data_in;
//     end
    
    // TODO: 添加32个寄存器组的输出
    assign chip_debug_out0 = pc_out;
    assign chip_debug_out1 = inst;
    assign chip_debug_out2 = addr_out;
    assign chip_debug_out3 = out;
    assign chip_debug_out4 = cache_out;
endmodule
