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
    input [31:0]cache_req_addr,  //��ˮ�߷����Ķ�д��ַ
    input [31:0]cache_req_data,  //д������
    input cache_req_wen, //дʹ��
    input cache_req_valid, //����cache�Ķ�д�������Ч��
    output reg[31:0]cache_resp_data, //����ˮ���ύ����������
    output reg cache_resp_stall, //��ˮ���Ƿ���Ҫ����Stall
    output reg[31:0]mem_req_addr, //����Memory�Ķ�/д��ַ
    output reg[31:0]mem_req_data, //����Memoryд������
    output reg mem_req_wen, //Memoryдʹ��
    output reg mem_req_valid,  //����Memory�Ķ�д�������Ч��
    input [31:0]mem_resp_data, //�ڴ淵������
    input mem_resp_valid, //Memory���ݲ�ѯ���
    
    input [31:0]inst, //�۲�Ҫ��Ҫstall�ģ����������inst�ж�
    output [31:0]cache_out
);

reg [31:0] data[0:127];
reg [26:0] addr[0:127]; //[26:2]��tag ,[1:0]�ֱ���dirty��valid, index���±�
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
    else if(mem_resp_valid)begin //��mem�õ�����
        //data[(cache_req_addr/4)%128] <= mem_resp_data;
        addr[(cache_req_addr/4)%128][26:2] <= cache_req_addr[31:7];
        addr[(cache_req_addr/4)%128][1] <= 0; //dirtyλ��0
        addr[(cache_req_addr/4)%128][0] <= 1; //validλ��1
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
    if(cache_req_wen == 0 && cache_req_valid == 1)begin //��Ч��
        if(addr[(cache_req_addr/4)%128][26:2] == cache_req_addr[31:7] && valid[(cache_req_addr/4)%128] && addr[(cache_req_addr/4)%128][0])begin //����
            cache_resp_data <= data[(cache_req_addr/4)%128];
            mem_req_valid <= 0;
            cache_resp_stall <= 0;
            //flag <= 0;
        end
        else begin //miss
            if(addr[(cache_req_addr/4)%128][1] == 0 && valid[(cache_req_addr/4)%128])begin //����������
                mem_req_addr <= cache_req_addr;
                mem_req_wen <= 0;
                mem_req_valid <= 1;
                valid[(cache_req_addr/4)%128] <= 0; //����validΪ0�������ȴ��׶�
                cache_resp_stall <= 1;
                //flag <= 0;
            end
            else if(addr[(cache_req_addr/4)%128][1] == 1 && valid[(cache_req_addr/4)%128])begin //����������
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
    
    else if(cache_req_wen == 1 && cache_req_valid == 1)begin //��Чд
        if(addr[(cache_req_addr/4)%128][26:2] == cache_req_addr[31:7] && valid[(cache_req_addr/4)%128] && addr[(cache_req_addr/4)%128][0])begin //����
            data[(cache_req_addr/4)%128] <= cache_req_data;
            addr[(cache_req_addr/4)%128][1] <= 1; //cache��Ϊд�������Ѿ�������������dirtyλ��1
            mem_req_valid <= 0;
            cache_resp_stall <= 0;
            //flag <= 0;
        end
        else begin //miss
            if(addr[(cache_req_addr/4)%128][1] == 0 && valid[(cache_req_addr/4)%128])begin //����������
                mem_req_addr <= cache_req_addr;
                mem_req_wen <= 0;
                mem_req_valid <= 1;
                valid[(cache_req_addr/4)%128] <= 0; //ȥ���ڴ����ݣ������ȴ��׶Σ�valid��0
                //data[(cache_req_addr/4)%128] <= cache_req_data;
                cache_resp_stall <= 1;
                //flag <= 0;
            end
            else if(addr[(cache_req_addr/4)%128][1] == 1 && valid[(cache_req_addr/4)%128])begin //��������
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
    
//    if(mem_resp_valid)begin //��mem�õ�����
//        //data[(cache_req_addr/4)%128] <= mem_resp_data;
//        addr[(cache_req_addr/4)%128][26:2] <= cache_req_addr[31:7];
//        addr[(cache_req_addr/4)%128][1] <= 0; //dirtyλ��0
//        addr[(cache_req_addr/4)%128][0] <= 1; //validλ��1
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
