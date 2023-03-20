`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 01:50:50
// Design Name: 
// Module Name: D_cache
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


module D_cache(
    input clk,
    input rst,
    input [31:0]cache_req_addr,  //流水线发出的读写地址
    input [31:0]cache_req_data,  //写入数据
    input cache_req_wen, //写使能
    input cache_req_valid, //发往cache的读写请求的有效性
    output reg[31:0]cache_resp_data, //向流水线提交的数据内容
    output reg cache_resp_stall, //流水线是否需要继续Stall
    output reg[31:0]mem_req_addr, //发往Memory的读/写地址
    output reg[31:0]mem_req_data, //发往Memory写入数据
    output reg mem_req_wen, //Memory写使能
    output reg mem_req_valid,  //发往Memory的读写请求的有效性
    input [31:0]mem_resp_data, //内存返回数据
    input mem_resp_valid, //Memory数据查询完成
    
    input [31:0]inst, //观察要不要stall的，根据输入的inst判断
    output [31:0]cache_out
);

reg [31:0] data[0:127];
reg [26:0] addr[0:127]; //[26:2]是tag ,[1:0]分别是dirty和valid, index是下标
reg [31:0] data_tmp;
reg [1:0] cnt;
reg valid[0:127];
integer i;

always@(negedge clk or posedge rst)begin
    if(rst)begin
        cnt <= 0;
    end
    else if(cnt == 2'b10)begin
        cnt <= cnt;
    end
    else begin
        cnt <= cnt + 1;
    end
end

always@(negedge clk or posedge rst)begin
    if(rst)begin
       for(i = 0; i < 128; i = i+1)begin
            data[i] <= 0;
            addr[i] <= 0;
            valid[i] <= 1;
       end
       //flag <= 0;
    end
//    else if(rst)begin
//        for(i = 0; i < 128; i = i+1)begin
//            data[i] <= 0;
//            addr[i] <= 0;
//       end
//    end
    else if(mem_resp_valid)begin //从mem拿到数据
        //data[(cache_req_addr/4)%128] <= mem_resp_data;
        addr[(cache_req_addr/4)%128][26:2] <= cache_req_addr[31:7];
        addr[(cache_req_addr/4)%128][1] <= 0; //dirty位置0
        addr[(cache_req_addr/4)%128][0] <= 1; //valid位置1
        valid[(cache_req_addr/4)%128] <= 1;
        //cache_resp_stall <= 0;
        if(cache_req_wen == 0 && cache_req_valid == 1)begin
            cache_resp_data <= data_tmp;
            data[(cache_req_addr/4)%128] <= data_tmp;
            mem_req_valid <= 0;
            cache_resp_stall <= 0;
        end
    end                
   else begin
    if(cache_req_wen == 0 && cache_req_valid == 1)begin //有效读
        if(addr[(cache_req_addr/4)%128][26:2] == cache_req_addr[31:7] && valid[(cache_req_addr/4)%128] && addr[(cache_req_addr/4)%128][0])begin //命中
            cache_resp_data <= data[(cache_req_addr/4)%128];
            mem_req_valid <= 0;
            cache_resp_stall <= 0;
            //flag <= 0;
        end
        else begin //miss
            if(addr[(cache_req_addr/4)%128][1] == 0 && valid[(cache_req_addr/4)%128])begin //不是脏数据
                mem_req_addr <= cache_req_addr;
                mem_req_wen <= 0;
                mem_req_valid <= 1;
                valid[(cache_req_addr/4)%128] <= 0; //设置valid为0，跳到等待阶段
                cache_resp_stall <= 1;
                //flag <= 0;
            end
            else if(addr[(cache_req_addr/4)%128][1] == 1 && valid[(cache_req_addr/4)%128])begin //存在脏数据
                mem_req_addr <= cache_req_addr;
                mem_req_data <= data[(cache_req_addr/4)%128];
                mem_req_wen <= 1;
                mem_req_valid <= 1;
                valid[(cache_req_addr/4)%128] <= 0;
                cache_resp_stall <= 1;
                //flag <= 0;
            end
        end
    end
    
    else if(cache_req_wen == 1 && cache_req_valid == 1)begin //有效写
        if(addr[(cache_req_addr/4)%128][26:2] == cache_req_addr[31:7] && valid[(cache_req_addr/4)%128] && addr[(cache_req_addr/4)%128][0])begin //命中
            data[(cache_req_addr/4)%128] <= cache_req_data;
            addr[(cache_req_addr/4)%128][1] <= 1; //cache因为写入数据已经和主存产生差别，dirty位置1
            mem_req_valid <= 0;
            cache_resp_stall <= 0;
            //flag <= 0;
        end
        else begin //miss
            if(addr[(cache_req_addr/4)%128][1] == 0 && valid[(cache_req_addr/4)%128])begin //不是脏数据
                mem_req_addr <= cache_req_addr;
                mem_req_wen <= 0;
                mem_req_valid <= 1;
                valid[(cache_req_addr/4)%128] <= 0; //去读内存数据，跳到等待阶段，valid置0
                //data[(cache_req_addr/4)%128] <= cache_req_data;
                cache_resp_stall <= 1;
                //flag <= 0;
            end
            else if(addr[(cache_req_addr/4)%128][1] == 1 && valid[(cache_req_addr/4)%128])begin //是脏数据
                mem_req_addr <= cache_req_addr;
                mem_req_data <= data[(cache_req_addr/4)%128];
                mem_req_wen <= 1;
                mem_req_valid <= 1;
                valid[(cache_req_addr/4)%128] <= 0;
                cache_resp_stall <= 1;
                //flag <= 0;
            end
        end  
    end
    
//    if(mem_resp_valid)begin //从mem拿到数据
//        //data[(cache_req_addr/4)%128] <= mem_resp_data;
//        addr[(cache_req_addr/4)%128][26:2] <= cache_req_addr[31:7];
//        addr[(cache_req_addr/4)%128][1] <= 0; //dirty位置0
//        addr[(cache_req_addr/4)%128][0] <= 1; //valid位置1
//        //cache_resp_stall <= 0;
//        if(cache_req_wen == 0 && cache_req_valid == 1)begin
//            cache_resp_data <= data_tmp;
//            data[(cache_req_addr/4)%128] <= data_tmp;
//            mem_req_valid <= 0;
//            cache_resp_stall <= 0;
//        end
//    end                
end
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        data_tmp <= 0;
    end
    else if(!mem_resp_valid)begin
        data_tmp <= mem_resp_data;
    end
    else begin
        data_tmp <= data_tmp;
    end
end
assign cache_out = data[1];
endmodule
