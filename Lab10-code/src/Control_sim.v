module Control(
input [6:0] op_code,
input [2:0] funct3,
input funct7_5,
output reg [1:0] pc_src,
output reg reg_write,
output reg alu_src_b,
output reg [3:0] alu_op,
output reg [1:0] mem_to_reg,
output reg mem_write,
output reg branch,
output reg b_type
);
`include "AluOp.vh"
always @* begin
pc_src = 0;
reg_write = 0;
alu_src_b = 0;
alu_op = {funct7_5, funct3};
mem_to_reg = 0;
mem_write = 0;
branch = 0;
b_type = 1'b0;
case (op_code)
7'b0110111: begin pc_src = 2'b00; reg_write = 1'b1; mem_to_reg = 2'b01; end // LUI
7'b0010011: begin pc_src = 2'b00;reg_write = 1'b1;end//addi
7'b1100011:begin pc_src = 2'b10;branch = 1'b1;end//bne
7'b0000011:begin pc_src = 2'b00;alu_src_b = 1'b1;mem_to_reg = 2'b01;reg_write = 1'b1;end//lw
7'b0100011:begin pc_src = 2'b00;alu_src_b = 1'b1;mem_write = 1'b1;end//sw

default: alu_op = 0;
endcase
end
endmodule
