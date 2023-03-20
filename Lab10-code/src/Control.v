`timescale 1ns / 1ps
module Control(
    input [6:0]op_code,
    input [2:0]funct3,
    input funct7_5,
    input [6:0]ecall_or_mret,
    input [31:0]inst,
    output reg [1:0]pc_src,
    output reg reg_write,
    output reg alu_src_b,
    output reg [3:0]alu_op,
    output reg [2:0]mem_to_reg,
    output reg mem_write,
    output reg branch,
    output reg [2:0] b_type,
    output reg lui_flag,
    output reg [2:0]csr_flag,
    output reg auipc_flag,
    output reg mret_flag,
    
    output reg [1:0]csr_addr
    );
    `include"AluOp.vh"
    always @(*)
    begin
        pc_src <= 0;
        reg_write <= 0;
        alu_src_b <= 0;
        alu_op <= {funct7_5,funct3};
        mem_to_reg <= 0;
        mem_write <= 0;
        branch <= 0;
        b_type <= 1'b0;
        lui_flag <= 0;
        csr_flag <= 1'b0;
        auipc_flag <= 1'b0;
        mret_flag <= 1'b0;
        csr_addr <= 2'b00;
        case(op_code)
            7'b0110111:  //lui
            begin 
                alu_op <= 4'b0000;
                reg_write <= 1'b1;
                mem_to_reg <= 2'b01;
                lui_flag <= 1;
            end
            7'b0110011: reg_write <= 1'b1;  //R-type
            7'b0000011:   //lw
            begin
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                alu_op <= 0;
                mem_to_reg <= 2'b11;
            end
            7'b0100011:  //sw
            begin
                alu_src_b <= 1'b1;
                alu_op <= 0;
                mem_write <= 1'b1;
            end
            7'b0010011:  //I-type
            begin
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                if(funct3 == 0)begin
                  alu_op <= 0;
                end
                else if(funct3 == 2)begin
                   alu_op <= 4'b0010;
                end
                else if(funct3 == 6)begin
                  alu_op <= 4'b0110;
                end
            end
            7'b1100011:  //B-type
            begin
                pc_src <= 2'b10;
                alu_op <= 4'b1000;
                branch <= 1'b1;
                if(funct3 == 0)begin
                    b_type <= 1;
                end
                else if(funct3 == 3'b111)begin
                    b_type <= 7;
                end
            end
            7'b1101111: //jal
            begin
                mem_to_reg <= 2'b10;
                reg_write <= 1'b1;
                pc_src <= 2'b10;
            end
            7'b1100111:  //jalr
            begin
              mem_to_reg <= 2'b10;
              reg_write <= 1'b1;
              pc_src <= 2'b01;
            end
            7'b1110011:  
            
            begin
            case(inst[31:20])
                12'b001100000000: csr_addr <= 2'b01; //mstatus
                12'b001100000101: csr_addr <= 2'b10; //mtvec
                12'b001101000001: csr_addr <= 2'b11; //mepc
                default:csr_addr <= 2'b00;
            endcase
              if(funct3 == 3'b001)begin  //csrrw
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                alu_op <= 4'b0000;
                csr_flag <= 3'b001;
              end
              else if(funct3 == 3'b010)begin //csrrs
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                alu_op <= 4'b0000;
                csr_flag <= 3'b010;
              end
              else if(funct3 == 3'b011)begin //csrrc
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                alu_op <= 4'b0000;
                csr_flag <= 3'b011;
              end
              else if(funct3 == 3'b101)begin //csrrwi
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                alu_op <= 4'b0000;
                csr_flag <= 3'b101;
              end
              else if(funct3 == 3'b110)begin //csrrsi
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                alu_op <= 4'b000;
                csr_flag <= 3'b110;
              end
              else if(funct3 == 3'b111)begin //csrrci
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                alu_op <= 4'b0000;
                csr_flag <= 3'b111;
              end
              else if(funct3 == 3'b000)begin //ecall or mret
                if(ecall_or_mret == 7'b0000000)begin //ecall
                    mem_to_reg <= 2'b10;
                    reg_write <= 1'b1;
                    pc_src <= 2'b01; 
                    csr_flag <= 3'b100;
                end
                else if(ecall_or_mret == 7'b0011000)begin //mret
                    mem_to_reg <= 2'b10;
                    reg_write <= 1'b1;
                    pc_src <= 2'b01;
                    csr_flag <= 3'b100;
                    mret_flag <= 1'b1;
                    alu_src_b <= 1'b1;
                end
            end
            end
            7'b0010111: //auipc
            begin
                reg_write <= 1'b1;
                alu_src_b <= 1'b1;
                auipc_flag <= 1'b1;
            end
            default: alu_op <= 0;
        endcase
    end
endmodule
