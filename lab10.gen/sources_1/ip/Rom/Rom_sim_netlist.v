// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Thu Jul  8 17:34:54 2021
// Host        : DESKTOP-92UJ649 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/Fcr/Desktop/lab10/lab10/lab10.gen/sources_1/ip/Rom/Rom_sim_netlist.v
// Design      : Rom
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Rom,dist_mem_gen_v8_0_13,{}" *) (* ORIG_REF_NAME = "xil_defaultlib_Rom" *) (* downgradeipidentifiedwarnings = "yes" *) 
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module Rom
   (a,
    spo);
  input [10:0]a;
  output [31:0]spo;

  wire [10:0]a;
  wire [31:0]spo;
  wire [31:0]NLW_U0_dpo_UNCONNECTED;
  wire [31:0]NLW_U0_qdpo_UNCONNECTED;
  wire [31:0]NLW_U0_qspo_UNCONNECTED;

  (* C_FAMILY = "artix7" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_DPO = "0" *) 
  (* C_HAS_DPRA = "0" *) 
  (* C_HAS_I_CE = "0" *) 
  (* C_HAS_QDPO = "0" *) 
  (* C_HAS_QDPO_CE = "0" *) 
  (* C_HAS_QDPO_CLK = "0" *) 
  (* C_HAS_QDPO_RST = "0" *) 
  (* C_HAS_QDPO_SRST = "0" *) 
  (* C_HAS_WE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_PIPELINE_STAGES = "0" *) 
  (* C_QCE_JOINED = "0" *) 
  (* C_QUALIFY_WE = "0" *) 
  (* C_REG_DPRA_INPUT = "0" *) 
  (* c_addr_width = "11" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "2048" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_clk = "0" *) 
  (* c_has_qspo = "0" *) 
  (* c_has_qspo_ce = "0" *) 
  (* c_has_qspo_rst = "0" *) 
  (* c_has_qspo_srst = "0" *) 
  (* c_has_spo = "1" *) 
  (* c_mem_init_file = "Rom.mif" *) 
  (* c_parser_type = "1" *) 
  (* c_read_mif = "1" *) 
  (* c_reg_a_d_inputs = "0" *) 
  (* c_sync_enable = "1" *) 
  (* c_width = "32" *) 
  (* is_du_within_envelope = "true" *) 
  Rom_dist_mem_gen_v8_0_13 U0
       (.a(a),
        .clk(1'b0),
        .d({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dpo(NLW_U0_dpo_UNCONNECTED[31:0]),
        .dpra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .i_ce(1'b1),
        .qdpo(NLW_U0_qdpo_UNCONNECTED[31:0]),
        .qdpo_ce(1'b1),
        .qdpo_clk(1'b0),
        .qdpo_rst(1'b0),
        .qdpo_srst(1'b0),
        .qspo(NLW_U0_qspo_UNCONNECTED[31:0]),
        .qspo_ce(1'b1),
        .qspo_rst(1'b0),
        .qspo_srst(1'b0),
        .spo(spo),
        .we(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
AWk2+F/LLIwJ/3H70MT+p73z+MaZAUnylB9xu/zfH66xX8dAaOizqpslZkE4MXrWhxdHpghP7sIj
kwvWqhJ3gA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
f3tnX2YCmmij/BT714m5fPTuG3pr/Sp1bWD1FpCFiwTkcUFmqMNcr7abCn+qa2HUp1VAs9a1kY1i
yU68W3C4ARAx1rnlow3CtMBZ+4vG1QDA+Ciu5T+MSJsiWTAoMU3jJunULwD6zEC9h/Y3bBf+ZNGj
RvbKgHQFYSq+EYUzleQ=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
C6xRmzJVnvguMc3Lt5tkoyg5+/u1VuxRooNBOmgUvD6c148xX9CV/zz4fw53vbCzqUg3WYMPAs5M
/tMrhPMrX5cqjMMHbC20NaFxsFGCfdbN+1Jiu6Ffu0obXLvBu7UGBCEaDTCY0wST3S+7NZ+HnAat
RIt5cVRmnWtLEj9MP8SxAk019LKc3+2AUY0eWFhWbTGvNoTLcRFak8vqIx8KBuqhc16O50jjNmM3
PJltfibMKzAmWpsf6xiOkaD+BvARuccAoYGgANLBAEQdJUza98//SuTN0KLZKbFSmy2WI5iAzkxJ
bhH9hPn6Ks1JkH9+j61hMSpdxSh8rM8X8Dppxw==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
pefxdCU7VwYHa7diZaenheQOVCFpIvDlVp0qUtYsCnfw3IK+d5+k4O7xc5MWvQPeJpwUWNg+c9U8
PcbHo1enWoVg9o1V4U5fg7wxYqKmubBjgGF3yJ5FYGt6FeiD7zcnIJcaP2puAYDdVnxtiJnNmFz2
OQ7UQsleDpBQo3E4NEsbtqgSaopjHREMjI4yjJ9l5XZYNPCWUzUV/mSGX/kF+vuSOZclwPm6w72e
TE0MyJZA2HPDY3HIy260pYSHuDTUpe8gTxi0s8JmpFjaMaibBcPzq2gqPSQe1d6pDE8cv0OxNYKL
gFy+uh/H5gpNjfWVBhRmUo/kFf8fs680z0B0IQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
q8meW/DFYsK3R2jTQ13P/a1BVQyF0Eb3aLhqxNSrqINAq7gQ0DvJ6JFuxd6Ce7TIpxqKUYX9026h
UujOPWt7f1brVrSWmt8cW5Um2Yy8tv+YSNv9Ig592u4GssTU6dF978RK/7L4ZuQObLOKvWLJqo3F
6gzw0VbqYS3g5aaGu+Y=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GVM7UoBz9uTOdnKd0CVM0lBuJK2N20FwcoiRGregMBQMsQuevbc7y03ZehM7mfGvEdERp1TciWoI
1b6cDAZYb0YBfSuch0bItCwhdftV3A4/R0nUF0HROsZ/rm/HV7DKDXxItqK0qcdOwqf7ju85NMa4
FJRP/Nuq/ya9IvX9BCpmUlT7tLkICG8cEL8/iJrJY3jRIBtKw85mL5OM+r22LQeYg1/3rb9Rk9BT
RZCTbDcVSUq2Awr+6f0L2NXlRwhFraBy+h9iSZKZ/U7uolyF0nB1+/BSgOl+rttZ2KxfLXe6g81N
FbxtrlpK7FNc9fx2jrKWh5bczyW6p0ATPX0ZbA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rYkJ9a3QzTBGC5CITub5Su2Qs6nnM1m+OFLf4ykZkZGIsp11NQi6h5t8dsi/rX/MeEof1XLVJGEU
N+qLOHuLrttRAipPNBsj7yqH3Amnleqy/rjy8UcckD0gxIYzuIlc+2VKoAoyrEFgofTH5bKzBaaQ
q0JSt8PES8xuld4SvsKwr+0Q23qJIUpeNL3HvzxZDmYf5OhTkwlZPi/aLwSMoPZHKwetLUg5SdBm
7K4UmxvUPD3GNxo6GW6dkG2tFW/N9+ju7i//O1A74VUrDPo1OwQfEJazwHFFpHGjCJkv2CiPU3+I
TIVvzssQcs8IphMJulwZguc7fFiYv6aZyj/GrA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PqIVM68d++A6qxRgSePlX8JOoCfHcFLdhzsYr1BDYvLE5JJ5WKFO0Bie6pyEiAbsH8z6oUFGm/Qy
BLXAyWfv1fmbVAwztezaMaxBF0Lw4epvQlAFVdMGJVKgvxfU7ssvLc1KfpF6R/c1o5+4Vf7zn3X+
R8k67LVYgJoxhrPoY3XYr88CjSITfNW0jLDjh0jtDWf7H7nM6QYSXVbRYczQPcepXW2MOFcCZsbi
tdla+UNJ4NeKTUK5bdE9tNZx/8BYKrJtLhyvNdwHi7EdonKLjQu63ExIHoriUmiZScMNbtr2LUBc
YYGUTIENquQ/OhU+DAVXmKbIZcQhwGaqjYeaag==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YMvD1GHkklhDlN9yur11SqhNZTItCRHxHobZtty993SsbvXTWJBbLeIJ+nQ/sv57gpjV5RswiJYh
Vu7QPlLUy2DbVjjcqxaxXlPvYaWV1eKD7BVBOV6HDzPAaAIaFvNjeRurYX0a9Dz1qkgkmttneZxB
s04mTyRdVOc7jIs5wjgXiF+iA0W50/g9JmIYyP6mMLkgEy0MbGyVfpbRfDMcrB3ACnucHTo8A0nT
V/rBUOGbTCYPmQ01tbuE2nqoEfTlmqHVKO6BZ93tQUEjrYoJdteva6yHUfH3dbV1vwwBtsdolICY
7x8cMlorxb6y2ZD7vQEYz6Q6iVnG/PmdaCkLSg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19968)
`pragma protect data_block
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
w4+D3lWgjQH1Zv1gkwoGTbVA
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
