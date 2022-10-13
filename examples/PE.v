module coreir_ule #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output out
);
  assign out = in0 <= in1;
endmodule

module coreir_uge #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output out
);
  assign out = in0 >= in1;
endmodule

module coreir_sle #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output out
);
  assign out = $signed(in0) <= $signed(in1);
endmodule

module coreir_sge #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output out
);
  assign out = $signed(in0) >= $signed(in1);
endmodule

module coreir_not #(
    parameter width = 1
) (
    input [width-1:0] in,
    output [width-1:0] out
);
  assign out = ~in;
endmodule

module coreir_mux #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    input sel,
    output [width-1:0] out
);
  assign out = sel ? in1 : in0;
endmodule

module coreir_mul #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output [width-1:0] out
);
  assign out = in0 * in1;
endmodule

module coreir_lshr #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output [width-1:0] out
);
  assign out = in0 >> in1;
endmodule

module coreir_eq #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output out
);
  assign out = in0 == in1;
endmodule

module coreir_const #(
    parameter width = 1,
    parameter value = 1
) (
    output [width-1:0] out
);
  assign out = value;
endmodule

module coreir_ashr #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output [width-1:0] out
);
  assign out = $signed(in0) >>> in1;
endmodule

module coreir_add #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output [width-1:0] out
);
  assign out = in0 + in1;
endmodule

module corebit_xor (
    input in0,
    input in1,
    output out
);
  assign out = in0 ^ in1;
endmodule

module corebit_or (
    input in0,
    input in1,
    output out
);
  assign out = in0 | in1;
endmodule

module corebit_not (
    input in,
    output out
);
  assign out = ~in;
endmodule

module corebit_const #(
    parameter value = 1
) (
    output out
);
  assign out = value;
endmodule

module corebit_and (
    input in0,
    input in1,
    output out
);
  assign out = in0 & in1;
endmodule

module commonlib_muxn__N2__width32 (
    input [31:0] in_data [1:0],
    input [0:0] in_sel,
    output [31:0] out
);
wire [31:0] _join_out;
coreir_mux #(
    .width(32)
) _join (
    .in0(in_data[0]),
    .in1(in_data[1]),
    .sel(in_sel[0]),
    .out(_join_out)
);
assign out = _join_out;
endmodule

module commonlib_muxn__N2__width16 (
    input [15:0] in_data [1:0],
    input [0:0] in_sel,
    output [15:0] out
);
wire [15:0] _join_out;
coreir_mux #(
    .width(16)
) _join (
    .in0(in_data[0]),
    .in1(in_data[1]),
    .sel(in_sel[0]),
    .out(_join_out)
);
assign out = _join_out;
endmodule

module commonlib_muxn__N2__width1 (
    input [0:0] in_data [1:0],
    input [0:0] in_sel,
    output [0:0] out
);
wire [0:0] _join_out;
coreir_mux #(
    .width(1)
) _join (
    .in0(in_data[0]),
    .in1(in_data[1]),
    .sel(in_sel[0]),
    .out(_join_out)
);
assign out = _join_out;
endmodule

module SUB (
    input [15:0] a,
    input [15:0] b,
    output [15:0] O0,
    output O1,
    output O2,
    output O3,
    output O4,
    output O5,
    input CLK,
    input ASYNCRESET
);
wire bit_const_0_None_out;
wire [15:0] const_0_16_out;
wire [16:0] const_1_17_out;
wire magma_Bit_and_inst0_out;
wire magma_Bit_and_inst1_out;
wire magma_Bit_and_inst2_out;
wire magma_Bit_and_inst3_out;
wire magma_Bit_not_inst0_out;
wire magma_Bit_not_inst1_out;
wire magma_Bit_not_inst2_out;
wire magma_Bit_or_inst0_out;
wire [15:0] magma_Bits_16_not_inst0_out;
wire magma_UInt_16_eq_inst0_out;
wire [16:0] magma_UInt_17_add_inst0_out;
wire [16:0] magma_UInt_17_add_inst1_out;
corebit_const #(
    .value(1'b0)
) bit_const_0_None (
    .out(bit_const_0_None_out)
);
coreir_const #(
    .value(16'h0000),
    .width(16)
) const_0_16 (
    .out(const_0_16_out)
);
coreir_const #(
    .value(17'h00001),
    .width(17)
) const_1_17 (
    .out(const_1_17_out)
);
corebit_and magma_Bit_and_inst0 (
    .in0(a[15]),
    .in1(magma_Bits_16_not_inst0_out[15]),
    .out(magma_Bit_and_inst0_out)
);
corebit_and magma_Bit_and_inst1 (
    .in0(magma_Bit_and_inst0_out),
    .in1(magma_Bit_not_inst0_out),
    .out(magma_Bit_and_inst1_out)
);
corebit_and magma_Bit_and_inst2 (
    .in0(magma_Bit_not_inst1_out),
    .in1(magma_Bit_not_inst2_out),
    .out(magma_Bit_and_inst2_out)
);
corebit_and magma_Bit_and_inst3 (
    .in0(magma_Bit_and_inst2_out),
    .in1(magma_UInt_17_add_inst1_out[15]),
    .out(magma_Bit_and_inst3_out)
);
corebit_not magma_Bit_not_inst0 (
    .in(magma_UInt_17_add_inst1_out[15]),
    .out(magma_Bit_not_inst0_out)
);
corebit_not magma_Bit_not_inst1 (
    .in(a[15]),
    .out(magma_Bit_not_inst1_out)
);
corebit_not magma_Bit_not_inst2 (
    .in(magma_Bits_16_not_inst0_out[15]),
    .out(magma_Bit_not_inst2_out)
);
corebit_or magma_Bit_or_inst0 (
    .in0(magma_Bit_and_inst1_out),
    .in1(magma_Bit_and_inst3_out),
    .out(magma_Bit_or_inst0_out)
);
coreir_not #(
    .width(16)
) magma_Bits_16_not_inst0 (
    .in(b),
    .out(magma_Bits_16_not_inst0_out)
);
coreir_eq #(
    .width(16)
) magma_UInt_16_eq_inst0 (
    .in0(magma_UInt_17_add_inst1_out[15:0]),
    .in1(const_0_16_out),
    .out(magma_UInt_16_eq_inst0_out)
);
wire [16:0] magma_UInt_17_add_inst0_in0;
assign magma_UInt_17_add_inst0_in0 = {bit_const_0_None_out,a[15:0]};
wire [16:0] magma_UInt_17_add_inst0_in1;
assign magma_UInt_17_add_inst0_in1 = {bit_const_0_None_out,magma_Bits_16_not_inst0_out[15:0]};
coreir_add #(
    .width(17)
) magma_UInt_17_add_inst0 (
    .in0(magma_UInt_17_add_inst0_in0),
    .in1(magma_UInt_17_add_inst0_in1),
    .out(magma_UInt_17_add_inst0_out)
);
coreir_add #(
    .width(17)
) magma_UInt_17_add_inst1 (
    .in0(magma_UInt_17_add_inst0_out),
    .in1(const_1_17_out),
    .out(magma_UInt_17_add_inst1_out)
);
assign O0 = magma_UInt_17_add_inst1_out[15:0];
assign O1 = magma_UInt_17_add_inst1_out[16];
assign O2 = magma_UInt_16_eq_inst0_out;
assign O3 = magma_UInt_17_add_inst1_out[15];
assign O4 = magma_UInt_17_add_inst1_out[16];
assign O5 = magma_Bit_or_inst0_out;
endmodule

module Mux2xUInt32 (
    input [31:0] I0,
    input [31:0] I1,
    input S,
    output [31:0] O
);
wire [31:0] coreir_commonlib_mux2x32_inst0_out;
wire [31:0] coreir_commonlib_mux2x32_inst0_in_data [1:0];
assign coreir_commonlib_mux2x32_inst0_in_data[1] = I1;
assign coreir_commonlib_mux2x32_inst0_in_data[0] = I0;
commonlib_muxn__N2__width32 coreir_commonlib_mux2x32_inst0 (
    .in_data(coreir_commonlib_mux2x32_inst0_in_data),
    .in_sel(S),
    .out(coreir_commonlib_mux2x32_inst0_out)
);
assign O = coreir_commonlib_mux2x32_inst0_out;
endmodule

module Mux2xUInt16 (
    input [15:0] I0,
    input [15:0] I1,
    input S,
    output [15:0] O
);
wire [15:0] coreir_commonlib_mux2x16_inst0_out;
wire [15:0] coreir_commonlib_mux2x16_inst0_in_data [1:0];
assign coreir_commonlib_mux2x16_inst0_in_data[1] = I1;
assign coreir_commonlib_mux2x16_inst0_in_data[0] = I0;
commonlib_muxn__N2__width16 coreir_commonlib_mux2x16_inst0 (
    .in_data(coreir_commonlib_mux2x16_inst0_in_data),
    .in_sel(S),
    .out(coreir_commonlib_mux2x16_inst0_out)
);
assign O = coreir_commonlib_mux2x16_inst0_out;
endmodule

module Mux2xBits16 (
    input [15:0] I0,
    input [15:0] I1,
    input S,
    output [15:0] O
);
wire [15:0] coreir_commonlib_mux2x16_inst0_out;
wire [15:0] coreir_commonlib_mux2x16_inst0_in_data [1:0];
assign coreir_commonlib_mux2x16_inst0_in_data[1] = I1;
assign coreir_commonlib_mux2x16_inst0_in_data[0] = I0;
commonlib_muxn__N2__width16 coreir_commonlib_mux2x16_inst0 (
    .in_data(coreir_commonlib_mux2x16_inst0_in_data),
    .in_sel(S),
    .out(coreir_commonlib_mux2x16_inst0_out)
);
assign O = coreir_commonlib_mux2x16_inst0_out;
endmodule

module SHR (
    input [0:0] signed_,
    input [15:0] a,
    input [15:0] b,
    output [15:0] O0,
    output O1,
    output O2,
    output O3,
    output O4,
    output O5,
    input CLK,
    input ASYNCRESET
);
wire [15:0] Mux2xBits16_inst0_O;
wire bit_const_0_None_out;
wire [15:0] const_0_16_out;
wire [0:0] const_1_1_out;
wire magma_Bits_16_eq_inst0_out;
wire magma_Bits_1_eq_inst0_out;
wire [15:0] magma_SInt_16_ashr_inst0_out;
wire [15:0] magma_UInt_16_lshr_inst0_out;
Mux2xBits16 Mux2xBits16_inst0 (
    .I0(magma_UInt_16_lshr_inst0_out),
    .I1(magma_SInt_16_ashr_inst0_out),
    .S(magma_Bits_1_eq_inst0_out),
    .O(Mux2xBits16_inst0_O)
);
corebit_const #(
    .value(1'b0)
) bit_const_0_None (
    .out(bit_const_0_None_out)
);
coreir_const #(
    .value(16'h0000),
    .width(16)
) const_0_16 (
    .out(const_0_16_out)
);
coreir_const #(
    .value(1'h1),
    .width(1)
) const_1_1 (
    .out(const_1_1_out)
);
coreir_eq #(
    .width(16)
) magma_Bits_16_eq_inst0 (
    .in0(Mux2xBits16_inst0_O),
    .in1(const_0_16_out),
    .out(magma_Bits_16_eq_inst0_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst0 (
    .in0(signed_),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst0_out)
);
coreir_ashr #(
    .width(16)
) magma_SInt_16_ashr_inst0 (
    .in0(a),
    .in1(b),
    .out(magma_SInt_16_ashr_inst0_out)
);
coreir_lshr #(
    .width(16)
) magma_UInt_16_lshr_inst0 (
    .in0(a),
    .in1(b),
    .out(magma_UInt_16_lshr_inst0_out)
);
assign O0 = Mux2xBits16_inst0_O;
assign O1 = bit_const_0_None_out;
assign O2 = magma_Bits_16_eq_inst0_out;
assign O3 = Mux2xBits16_inst0_O[15];
assign O4 = bit_const_0_None_out;
assign O5 = bit_const_0_None_out;
endmodule

module Mux2xBit (
    input I0,
    input I1,
    input S,
    output O
);
wire [0:0] coreir_commonlib_mux2x1_inst0_out;
wire [0:0] coreir_commonlib_mux2x1_inst0_in_data [1:0];
assign coreir_commonlib_mux2x1_inst0_in_data[1] = I1;
assign coreir_commonlib_mux2x1_inst0_in_data[0] = I0;
commonlib_muxn__N2__width1 coreir_commonlib_mux2x1_inst0 (
    .in_data(coreir_commonlib_mux2x1_inst0_in_data),
    .in_sel(S),
    .out(coreir_commonlib_mux2x1_inst0_out)
);
assign O = coreir_commonlib_mux2x1_inst0_out[0];
endmodule

module MUL (
    input [1:0] instr,
    input [0:0] signed_,
    input [15:0] a,
    input [15:0] b,
    output [15:0] O,
    input CLK,
    input ASYNCRESET
);
wire [15:0] Mux2xBits16_inst0_O;
wire [15:0] Mux2xBits16_inst1_O;
wire [15:0] Mux2xUInt16_inst0_O;
wire [15:0] Mux2xUInt16_inst1_O;
wire [31:0] Mux2xUInt32_inst0_O;
wire [31:0] Mux2xUInt32_inst1_O;
wire bit_const_0_None_out;
wire [15:0] const_0_16_out;
wire [1:0] const_0_2_out;
wire [0:0] const_1_1_out;
wire [1:0] const_1_2_out;
wire [1:0] const_2_2_out;
wire magma_Bits_1_eq_inst0_out;
wire magma_Bits_2_eq_inst0_out;
wire magma_Bits_2_eq_inst1_out;
wire magma_Bits_2_eq_inst2_out;
wire [31:0] magma_UInt_32_mul_inst0_out;
Mux2xBits16 Mux2xBits16_inst0 (
    .I0(a),
    .I1(const_0_16_out),
    .S(magma_Bits_2_eq_inst0_out),
    .O(Mux2xBits16_inst0_O)
);
Mux2xBits16 Mux2xBits16_inst1 (
    .I0(b),
    .I1(const_0_16_out),
    .S(magma_Bits_2_eq_inst0_out),
    .O(Mux2xBits16_inst1_O)
);
Mux2xUInt16 Mux2xUInt16_inst0 (
    .I0(magma_UInt_32_mul_inst0_out[15:0]),
    .I1(magma_UInt_32_mul_inst0_out[23:8]),
    .S(magma_Bits_2_eq_inst1_out),
    .O(Mux2xUInt16_inst0_O)
);
Mux2xUInt16 Mux2xUInt16_inst1 (
    .I0(Mux2xUInt16_inst0_O),
    .I1(magma_UInt_32_mul_inst0_out[15:0]),
    .S(magma_Bits_2_eq_inst2_out),
    .O(Mux2xUInt16_inst1_O)
);
wire [31:0] Mux2xUInt32_inst0_I0;
assign Mux2xUInt32_inst0_I0 = {bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,Mux2xBits16_inst0_O[15:0]};
wire [31:0] Mux2xUInt32_inst0_I1;
assign Mux2xUInt32_inst0_I1 = {Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15],Mux2xBits16_inst0_O[15:0]};
Mux2xUInt32 Mux2xUInt32_inst0 (
    .I0(Mux2xUInt32_inst0_I0),
    .I1(Mux2xUInt32_inst0_I1),
    .S(magma_Bits_1_eq_inst0_out),
    .O(Mux2xUInt32_inst0_O)
);
wire [31:0] Mux2xUInt32_inst1_I0;
assign Mux2xUInt32_inst1_I0 = {bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,bit_const_0_None_out,Mux2xBits16_inst1_O[15:0]};
wire [31:0] Mux2xUInt32_inst1_I1;
assign Mux2xUInt32_inst1_I1 = {Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15],Mux2xBits16_inst1_O[15:0]};
Mux2xUInt32 Mux2xUInt32_inst1 (
    .I0(Mux2xUInt32_inst1_I0),
    .I1(Mux2xUInt32_inst1_I1),
    .S(magma_Bits_1_eq_inst0_out),
    .O(Mux2xUInt32_inst1_O)
);
corebit_const #(
    .value(1'b0)
) bit_const_0_None (
    .out(bit_const_0_None_out)
);
coreir_const #(
    .value(16'h0000),
    .width(16)
) const_0_16 (
    .out(const_0_16_out)
);
coreir_const #(
    .value(2'h0),
    .width(2)
) const_0_2 (
    .out(const_0_2_out)
);
coreir_const #(
    .value(1'h1),
    .width(1)
) const_1_1 (
    .out(const_1_1_out)
);
coreir_const #(
    .value(2'h1),
    .width(2)
) const_1_2 (
    .out(const_1_2_out)
);
coreir_const #(
    .value(2'h2),
    .width(2)
) const_2_2 (
    .out(const_2_2_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst0 (
    .in0(signed_),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst0_out)
);
coreir_eq #(
    .width(2)
) magma_Bits_2_eq_inst0 (
    .in0(instr),
    .in1(const_1_2_out),
    .out(magma_Bits_2_eq_inst0_out)
);
coreir_eq #(
    .width(2)
) magma_Bits_2_eq_inst1 (
    .in0(instr),
    .in1(const_2_2_out),
    .out(magma_Bits_2_eq_inst1_out)
);
coreir_eq #(
    .width(2)
) magma_Bits_2_eq_inst2 (
    .in0(instr),
    .in1(const_0_2_out),
    .out(magma_Bits_2_eq_inst2_out)
);
coreir_mul #(
    .width(32)
) magma_UInt_32_mul_inst0 (
    .in0(Mux2xUInt32_inst0_O),
    .in1(Mux2xUInt32_inst1_O),
    .out(magma_UInt_32_mul_inst0_out)
);
assign O = Mux2xUInt16_inst1_O;
endmodule

module LTE (
    input [0:0] signed_,
    input [15:0] a,
    input [15:0] b,
    output [15:0] O0,
    output O1,
    output O2,
    output O3,
    output O4,
    output O5,
    input CLK,
    input ASYNCRESET
);
wire Mux2xBit_inst0_O;
wire [15:0] Mux2xBits16_inst0_O;
wire bit_const_0_None_out;
wire [15:0] const_0_16_out;
wire [0:0] const_1_1_out;
wire magma_Bits_16_eq_inst0_out;
wire magma_Bits_1_eq_inst0_out;
wire magma_SInt_16_sle_inst0_out;
wire magma_UInt_16_ule_inst0_out;
Mux2xBit Mux2xBit_inst0 (
    .I0(magma_UInt_16_ule_inst0_out),
    .I1(magma_SInt_16_sle_inst0_out),
    .S(magma_Bits_1_eq_inst0_out),
    .O(Mux2xBit_inst0_O)
);
Mux2xBits16 Mux2xBits16_inst0 (
    .I0(b),
    .I1(a),
    .S(Mux2xBit_inst0_O),
    .O(Mux2xBits16_inst0_O)
);
corebit_const #(
    .value(1'b0)
) bit_const_0_None (
    .out(bit_const_0_None_out)
);
coreir_const #(
    .value(16'h0000),
    .width(16)
) const_0_16 (
    .out(const_0_16_out)
);
coreir_const #(
    .value(1'h1),
    .width(1)
) const_1_1 (
    .out(const_1_1_out)
);
coreir_eq #(
    .width(16)
) magma_Bits_16_eq_inst0 (
    .in0(Mux2xBits16_inst0_O),
    .in1(const_0_16_out),
    .out(magma_Bits_16_eq_inst0_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst0 (
    .in0(signed_),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst0_out)
);
coreir_sle #(
    .width(16)
) magma_SInt_16_sle_inst0 (
    .in0(a),
    .in1(b),
    .out(magma_SInt_16_sle_inst0_out)
);
coreir_ule #(
    .width(16)
) magma_UInt_16_ule_inst0 (
    .in0(a),
    .in1(b),
    .out(magma_UInt_16_ule_inst0_out)
);
assign O0 = Mux2xBits16_inst0_O;
assign O1 = Mux2xBit_inst0_O;
assign O2 = magma_Bits_16_eq_inst0_out;
assign O3 = Mux2xBits16_inst0_O[15];
assign O4 = bit_const_0_None_out;
assign O5 = bit_const_0_None_out;
endmodule

module GTE (
    input [0:0] signed_,
    input [15:0] a,
    input [15:0] b,
    output [15:0] O0,
    output O1,
    output O2,
    output O3,
    output O4,
    output O5,
    input CLK,
    input ASYNCRESET
);
wire Mux2xBit_inst0_O;
wire [15:0] Mux2xBits16_inst0_O;
wire bit_const_0_None_out;
wire [15:0] const_0_16_out;
wire [0:0] const_1_1_out;
wire magma_Bits_16_eq_inst0_out;
wire magma_Bits_1_eq_inst0_out;
wire magma_SInt_16_sge_inst0_out;
wire magma_UInt_16_uge_inst0_out;
Mux2xBit Mux2xBit_inst0 (
    .I0(magma_UInt_16_uge_inst0_out),
    .I1(magma_SInt_16_sge_inst0_out),
    .S(magma_Bits_1_eq_inst0_out),
    .O(Mux2xBit_inst0_O)
);
Mux2xBits16 Mux2xBits16_inst0 (
    .I0(b),
    .I1(a),
    .S(Mux2xBit_inst0_O),
    .O(Mux2xBits16_inst0_O)
);
corebit_const #(
    .value(1'b0)
) bit_const_0_None (
    .out(bit_const_0_None_out)
);
coreir_const #(
    .value(16'h0000),
    .width(16)
) const_0_16 (
    .out(const_0_16_out)
);
coreir_const #(
    .value(1'h1),
    .width(1)
) const_1_1 (
    .out(const_1_1_out)
);
coreir_eq #(
    .width(16)
) magma_Bits_16_eq_inst0 (
    .in0(Mux2xBits16_inst0_O),
    .in1(const_0_16_out),
    .out(magma_Bits_16_eq_inst0_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst0 (
    .in0(signed_),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst0_out)
);
coreir_sge #(
    .width(16)
) magma_SInt_16_sge_inst0 (
    .in0(a),
    .in1(b),
    .out(magma_SInt_16_sge_inst0_out)
);
coreir_uge #(
    .width(16)
) magma_UInt_16_uge_inst0 (
    .in0(a),
    .in1(b),
    .out(magma_UInt_16_uge_inst0_out)
);
assign O0 = Mux2xBits16_inst0_O;
assign O1 = Mux2xBit_inst0_O;
assign O2 = magma_Bits_16_eq_inst0_out;
assign O3 = Mux2xBits16_inst0_O[15];
assign O4 = bit_const_0_None_out;
assign O5 = bit_const_0_None_out;
endmodule

module Cond (
    input [4:0] code,
    input alu,
    input Z,
    input N,
    input C,
    input V,
    output O,
    input CLK,
    input ASYNCRESET
);
wire Mux2xBit_inst0_O;
wire Mux2xBit_inst1_O;
wire Mux2xBit_inst10_O;
wire Mux2xBit_inst11_O;
wire Mux2xBit_inst12_O;
wire Mux2xBit_inst13_O;
wire Mux2xBit_inst14_O;
wire Mux2xBit_inst15_O;
wire Mux2xBit_inst16_O;
wire Mux2xBit_inst17_O;
wire Mux2xBit_inst2_O;
wire Mux2xBit_inst3_O;
wire Mux2xBit_inst4_O;
wire Mux2xBit_inst5_O;
wire Mux2xBit_inst6_O;
wire Mux2xBit_inst7_O;
wire Mux2xBit_inst8_O;
wire Mux2xBit_inst9_O;
wire [4:0] const_0_5_out;
wire [4:0] const_10_5_out;
wire [4:0] const_11_5_out;
wire [4:0] const_12_5_out;
wire [4:0] const_13_5_out;
wire [4:0] const_14_5_out;
wire [4:0] const_15_5_out;
wire [4:0] const_16_5_out;
wire [4:0] const_17_5_out;
wire [4:0] const_1_5_out;
wire [4:0] const_2_5_out;
wire [4:0] const_3_5_out;
wire [4:0] const_4_5_out;
wire [4:0] const_5_5_out;
wire [4:0] const_6_5_out;
wire [4:0] const_7_5_out;
wire [4:0] const_8_5_out;
wire [4:0] const_9_5_out;
wire magma_Bit_and_inst0_out;
wire magma_Bit_and_inst1_out;
wire magma_Bit_and_inst2_out;
wire magma_Bit_and_inst3_out;
wire magma_Bit_not_inst0_out;
wire magma_Bit_not_inst1_out;
wire magma_Bit_not_inst10_out;
wire magma_Bit_not_inst11_out;
wire magma_Bit_not_inst12_out;
wire magma_Bit_not_inst2_out;
wire magma_Bit_not_inst3_out;
wire magma_Bit_not_inst4_out;
wire magma_Bit_not_inst5_out;
wire magma_Bit_not_inst6_out;
wire magma_Bit_not_inst7_out;
wire magma_Bit_not_inst8_out;
wire magma_Bit_not_inst9_out;
wire magma_Bit_or_inst0_out;
wire magma_Bit_or_inst1_out;
wire magma_Bit_or_inst2_out;
wire magma_Bit_or_inst3_out;
wire magma_Bit_or_inst4_out;
wire magma_Bit_or_inst5_out;
wire magma_Bit_xor_inst0_out;
wire magma_Bit_xor_inst1_out;
wire magma_Bit_xor_inst2_out;
wire magma_Bit_xor_inst3_out;
wire magma_Bits_5_eq_inst0_out;
wire magma_Bits_5_eq_inst1_out;
wire magma_Bits_5_eq_inst10_out;
wire magma_Bits_5_eq_inst11_out;
wire magma_Bits_5_eq_inst12_out;
wire magma_Bits_5_eq_inst13_out;
wire magma_Bits_5_eq_inst14_out;
wire magma_Bits_5_eq_inst15_out;
wire magma_Bits_5_eq_inst16_out;
wire magma_Bits_5_eq_inst17_out;
wire magma_Bits_5_eq_inst18_out;
wire magma_Bits_5_eq_inst19_out;
wire magma_Bits_5_eq_inst2_out;
wire magma_Bits_5_eq_inst3_out;
wire magma_Bits_5_eq_inst4_out;
wire magma_Bits_5_eq_inst5_out;
wire magma_Bits_5_eq_inst6_out;
wire magma_Bits_5_eq_inst7_out;
wire magma_Bits_5_eq_inst8_out;
wire magma_Bits_5_eq_inst9_out;
Mux2xBit Mux2xBit_inst0 (
    .I0(magma_Bit_and_inst3_out),
    .I1(magma_Bit_or_inst5_out),
    .S(magma_Bits_5_eq_inst0_out),
    .O(Mux2xBit_inst0_O)
);
Mux2xBit Mux2xBit_inst1 (
    .I0(Mux2xBit_inst0_O),
    .I1(magma_Bit_and_inst2_out),
    .S(magma_Bits_5_eq_inst1_out),
    .O(Mux2xBit_inst1_O)
);
Mux2xBit Mux2xBit_inst10 (
    .I0(Mux2xBit_inst9_O),
    .I1(magma_Bit_not_inst3_out),
    .S(magma_Bits_5_eq_inst10_out),
    .O(Mux2xBit_inst10_O)
);
Mux2xBit Mux2xBit_inst11 (
    .I0(Mux2xBit_inst10_O),
    .I1(V),
    .S(magma_Bits_5_eq_inst11_out),
    .O(Mux2xBit_inst11_O)
);
Mux2xBit Mux2xBit_inst12 (
    .I0(Mux2xBit_inst11_O),
    .I1(magma_Bit_not_inst2_out),
    .S(magma_Bits_5_eq_inst12_out),
    .O(Mux2xBit_inst12_O)
);
Mux2xBit Mux2xBit_inst13 (
    .I0(Mux2xBit_inst12_O),
    .I1(N),
    .S(magma_Bits_5_eq_inst13_out),
    .O(Mux2xBit_inst13_O)
);
Mux2xBit Mux2xBit_inst14 (
    .I0(Mux2xBit_inst13_O),
    .I1(magma_Bit_not_inst1_out),
    .S(magma_Bit_or_inst0_out),
    .O(Mux2xBit_inst14_O)
);
Mux2xBit Mux2xBit_inst15 (
    .I0(Mux2xBit_inst14_O),
    .I1(C),
    .S(magma_Bit_or_inst1_out),
    .O(Mux2xBit_inst15_O)
);
Mux2xBit Mux2xBit_inst16 (
    .I0(Mux2xBit_inst15_O),
    .I1(magma_Bit_not_inst0_out),
    .S(magma_Bits_5_eq_inst18_out),
    .O(Mux2xBit_inst16_O)
);
Mux2xBit Mux2xBit_inst17 (
    .I0(Mux2xBit_inst16_O),
    .I1(Z),
    .S(magma_Bits_5_eq_inst19_out),
    .O(Mux2xBit_inst17_O)
);
Mux2xBit Mux2xBit_inst2 (
    .I0(Mux2xBit_inst1_O),
    .I1(magma_Bit_or_inst4_out),
    .S(magma_Bits_5_eq_inst2_out),
    .O(Mux2xBit_inst2_O)
);
Mux2xBit Mux2xBit_inst3 (
    .I0(Mux2xBit_inst2_O),
    .I1(alu),
    .S(magma_Bits_5_eq_inst3_out),
    .O(Mux2xBit_inst3_O)
);
Mux2xBit Mux2xBit_inst4 (
    .I0(Mux2xBit_inst3_O),
    .I1(magma_Bit_or_inst3_out),
    .S(magma_Bits_5_eq_inst4_out),
    .O(Mux2xBit_inst4_O)
);
Mux2xBit Mux2xBit_inst5 (
    .I0(Mux2xBit_inst4_O),
    .I1(magma_Bit_and_inst1_out),
    .S(magma_Bits_5_eq_inst5_out),
    .O(Mux2xBit_inst5_O)
);
Mux2xBit Mux2xBit_inst6 (
    .I0(Mux2xBit_inst5_O),
    .I1(magma_Bit_xor_inst1_out),
    .S(magma_Bits_5_eq_inst6_out),
    .O(Mux2xBit_inst6_O)
);
Mux2xBit Mux2xBit_inst7 (
    .I0(Mux2xBit_inst6_O),
    .I1(magma_Bit_not_inst6_out),
    .S(magma_Bits_5_eq_inst7_out),
    .O(Mux2xBit_inst7_O)
);
Mux2xBit Mux2xBit_inst8 (
    .I0(Mux2xBit_inst7_O),
    .I1(magma_Bit_or_inst2_out),
    .S(magma_Bits_5_eq_inst8_out),
    .O(Mux2xBit_inst8_O)
);
Mux2xBit Mux2xBit_inst9 (
    .I0(Mux2xBit_inst8_O),
    .I1(magma_Bit_and_inst0_out),
    .S(magma_Bits_5_eq_inst9_out),
    .O(Mux2xBit_inst9_O)
);
coreir_const #(
    .value(5'h00),
    .width(5)
) const_0_5 (
    .out(const_0_5_out)
);
coreir_const #(
    .value(5'h0a),
    .width(5)
) const_10_5 (
    .out(const_10_5_out)
);
coreir_const #(
    .value(5'h0b),
    .width(5)
) const_11_5 (
    .out(const_11_5_out)
);
coreir_const #(
    .value(5'h0c),
    .width(5)
) const_12_5 (
    .out(const_12_5_out)
);
coreir_const #(
    .value(5'h0d),
    .width(5)
) const_13_5 (
    .out(const_13_5_out)
);
coreir_const #(
    .value(5'h0e),
    .width(5)
) const_14_5 (
    .out(const_14_5_out)
);
coreir_const #(
    .value(5'h0f),
    .width(5)
) const_15_5 (
    .out(const_15_5_out)
);
coreir_const #(
    .value(5'h10),
    .width(5)
) const_16_5 (
    .out(const_16_5_out)
);
coreir_const #(
    .value(5'h11),
    .width(5)
) const_17_5 (
    .out(const_17_5_out)
);
coreir_const #(
    .value(5'h01),
    .width(5)
) const_1_5 (
    .out(const_1_5_out)
);
coreir_const #(
    .value(5'h02),
    .width(5)
) const_2_5 (
    .out(const_2_5_out)
);
coreir_const #(
    .value(5'h03),
    .width(5)
) const_3_5 (
    .out(const_3_5_out)
);
coreir_const #(
    .value(5'h04),
    .width(5)
) const_4_5 (
    .out(const_4_5_out)
);
coreir_const #(
    .value(5'h05),
    .width(5)
) const_5_5 (
    .out(const_5_5_out)
);
coreir_const #(
    .value(5'h06),
    .width(5)
) const_6_5 (
    .out(const_6_5_out)
);
coreir_const #(
    .value(5'h07),
    .width(5)
) const_7_5 (
    .out(const_7_5_out)
);
coreir_const #(
    .value(5'h08),
    .width(5)
) const_8_5 (
    .out(const_8_5_out)
);
coreir_const #(
    .value(5'h09),
    .width(5)
) const_9_5 (
    .out(const_9_5_out)
);
corebit_and magma_Bit_and_inst0 (
    .in0(C),
    .in1(magma_Bit_not_inst4_out),
    .out(magma_Bit_and_inst0_out)
);
corebit_and magma_Bit_and_inst1 (
    .in0(magma_Bit_not_inst7_out),
    .in1(magma_Bit_not_inst8_out),
    .out(magma_Bit_and_inst1_out)
);
corebit_and magma_Bit_and_inst2 (
    .in0(magma_Bit_not_inst10_out),
    .in1(magma_Bit_not_inst11_out),
    .out(magma_Bit_and_inst2_out)
);
corebit_and magma_Bit_and_inst3 (
    .in0(N),
    .in1(magma_Bit_not_inst12_out),
    .out(magma_Bit_and_inst3_out)
);
corebit_not magma_Bit_not_inst0 (
    .in(Z),
    .out(magma_Bit_not_inst0_out)
);
corebit_not magma_Bit_not_inst1 (
    .in(C),
    .out(magma_Bit_not_inst1_out)
);
corebit_not magma_Bit_not_inst10 (
    .in(N),
    .out(magma_Bit_not_inst10_out)
);
corebit_not magma_Bit_not_inst11 (
    .in(Z),
    .out(magma_Bit_not_inst11_out)
);
corebit_not magma_Bit_not_inst12 (
    .in(Z),
    .out(magma_Bit_not_inst12_out)
);
corebit_not magma_Bit_not_inst2 (
    .in(N),
    .out(magma_Bit_not_inst2_out)
);
corebit_not magma_Bit_not_inst3 (
    .in(V),
    .out(magma_Bit_not_inst3_out)
);
corebit_not magma_Bit_not_inst4 (
    .in(Z),
    .out(magma_Bit_not_inst4_out)
);
corebit_not magma_Bit_not_inst5 (
    .in(C),
    .out(magma_Bit_not_inst5_out)
);
corebit_not magma_Bit_not_inst6 (
    .in(magma_Bit_xor_inst0_out),
    .out(magma_Bit_not_inst6_out)
);
corebit_not magma_Bit_not_inst7 (
    .in(Z),
    .out(magma_Bit_not_inst7_out)
);
corebit_not magma_Bit_not_inst8 (
    .in(magma_Bit_xor_inst2_out),
    .out(magma_Bit_not_inst8_out)
);
corebit_not magma_Bit_not_inst9 (
    .in(N),
    .out(magma_Bit_not_inst9_out)
);
corebit_or magma_Bit_or_inst0 (
    .in0(magma_Bits_5_eq_inst14_out),
    .in1(magma_Bits_5_eq_inst15_out),
    .out(magma_Bit_or_inst0_out)
);
corebit_or magma_Bit_or_inst1 (
    .in0(magma_Bits_5_eq_inst16_out),
    .in1(magma_Bits_5_eq_inst17_out),
    .out(magma_Bit_or_inst1_out)
);
corebit_or magma_Bit_or_inst2 (
    .in0(magma_Bit_not_inst5_out),
    .in1(Z),
    .out(magma_Bit_or_inst2_out)
);
corebit_or magma_Bit_or_inst3 (
    .in0(Z),
    .in1(magma_Bit_xor_inst3_out),
    .out(magma_Bit_or_inst3_out)
);
corebit_or magma_Bit_or_inst4 (
    .in0(magma_Bit_not_inst9_out),
    .in1(Z),
    .out(magma_Bit_or_inst4_out)
);
corebit_or magma_Bit_or_inst5 (
    .in0(N),
    .in1(Z),
    .out(magma_Bit_or_inst5_out)
);
corebit_xor magma_Bit_xor_inst0 (
    .in0(N),
    .in1(V),
    .out(magma_Bit_xor_inst0_out)
);
corebit_xor magma_Bit_xor_inst1 (
    .in0(N),
    .in1(V),
    .out(magma_Bit_xor_inst1_out)
);
corebit_xor magma_Bit_xor_inst2 (
    .in0(N),
    .in1(V),
    .out(magma_Bit_xor_inst2_out)
);
corebit_xor magma_Bit_xor_inst3 (
    .in0(N),
    .in1(V),
    .out(magma_Bit_xor_inst3_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst0 (
    .in0(code),
    .in1(const_17_5_out),
    .out(magma_Bits_5_eq_inst0_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst1 (
    .in0(code),
    .in1(const_16_5_out),
    .out(magma_Bits_5_eq_inst1_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst10 (
    .in0(code),
    .in1(const_7_5_out),
    .out(magma_Bits_5_eq_inst10_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst11 (
    .in0(code),
    .in1(const_6_5_out),
    .out(magma_Bits_5_eq_inst11_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst12 (
    .in0(code),
    .in1(const_5_5_out),
    .out(magma_Bits_5_eq_inst12_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst13 (
    .in0(code),
    .in1(const_4_5_out),
    .out(magma_Bits_5_eq_inst13_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst14 (
    .in0(code),
    .in1(const_3_5_out),
    .out(magma_Bits_5_eq_inst14_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst15 (
    .in0(code),
    .in1(const_3_5_out),
    .out(magma_Bits_5_eq_inst15_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst16 (
    .in0(code),
    .in1(const_2_5_out),
    .out(magma_Bits_5_eq_inst16_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst17 (
    .in0(code),
    .in1(const_2_5_out),
    .out(magma_Bits_5_eq_inst17_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst18 (
    .in0(code),
    .in1(const_1_5_out),
    .out(magma_Bits_5_eq_inst18_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst19 (
    .in0(code),
    .in1(const_0_5_out),
    .out(magma_Bits_5_eq_inst19_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst2 (
    .in0(code),
    .in1(const_15_5_out),
    .out(magma_Bits_5_eq_inst2_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst3 (
    .in0(code),
    .in1(const_14_5_out),
    .out(magma_Bits_5_eq_inst3_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst4 (
    .in0(code),
    .in1(const_13_5_out),
    .out(magma_Bits_5_eq_inst4_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst5 (
    .in0(code),
    .in1(const_12_5_out),
    .out(magma_Bits_5_eq_inst5_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst6 (
    .in0(code),
    .in1(const_11_5_out),
    .out(magma_Bits_5_eq_inst6_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst7 (
    .in0(code),
    .in1(const_10_5_out),
    .out(magma_Bits_5_eq_inst7_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst8 (
    .in0(code),
    .in1(const_9_5_out),
    .out(magma_Bits_5_eq_inst8_out)
);
coreir_eq #(
    .width(5)
) magma_Bits_5_eq_inst9 (
    .in0(code),
    .in1(const_8_5_out),
    .out(magma_Bits_5_eq_inst9_out)
);
assign O = Mux2xBit_inst17_O;
endmodule

module ADD (
    input [15:0] a,
    input [15:0] b,
    output [15:0] O0,
    output O1,
    output O2,
    output O3,
    output O4,
    output O5,
    input CLK,
    input ASYNCRESET
);
wire bit_const_0_None_out;
wire [15:0] const_0_16_out;
wire [16:0] const_0_17_out;
wire magma_Bit_and_inst0_out;
wire magma_Bit_and_inst1_out;
wire magma_Bit_and_inst2_out;
wire magma_Bit_and_inst3_out;
wire magma_Bit_not_inst0_out;
wire magma_Bit_not_inst1_out;
wire magma_Bit_not_inst2_out;
wire magma_Bit_or_inst0_out;
wire magma_UInt_16_eq_inst0_out;
wire [16:0] magma_UInt_17_add_inst0_out;
wire [16:0] magma_UInt_17_add_inst1_out;
corebit_const #(
    .value(1'b0)
) bit_const_0_None (
    .out(bit_const_0_None_out)
);
coreir_const #(
    .value(16'h0000),
    .width(16)
) const_0_16 (
    .out(const_0_16_out)
);
coreir_const #(
    .value(17'h00000),
    .width(17)
) const_0_17 (
    .out(const_0_17_out)
);
corebit_and magma_Bit_and_inst0 (
    .in0(a[15]),
    .in1(b[15]),
    .out(magma_Bit_and_inst0_out)
);
corebit_and magma_Bit_and_inst1 (
    .in0(magma_Bit_and_inst0_out),
    .in1(magma_Bit_not_inst0_out),
    .out(magma_Bit_and_inst1_out)
);
corebit_and magma_Bit_and_inst2 (
    .in0(magma_Bit_not_inst1_out),
    .in1(magma_Bit_not_inst2_out),
    .out(magma_Bit_and_inst2_out)
);
corebit_and magma_Bit_and_inst3 (
    .in0(magma_Bit_and_inst2_out),
    .in1(magma_UInt_17_add_inst1_out[15]),
    .out(magma_Bit_and_inst3_out)
);
corebit_not magma_Bit_not_inst0 (
    .in(magma_UInt_17_add_inst1_out[15]),
    .out(magma_Bit_not_inst0_out)
);
corebit_not magma_Bit_not_inst1 (
    .in(a[15]),
    .out(magma_Bit_not_inst1_out)
);
corebit_not magma_Bit_not_inst2 (
    .in(b[15]),
    .out(magma_Bit_not_inst2_out)
);
corebit_or magma_Bit_or_inst0 (
    .in0(magma_Bit_and_inst1_out),
    .in1(magma_Bit_and_inst3_out),
    .out(magma_Bit_or_inst0_out)
);
coreir_eq #(
    .width(16)
) magma_UInt_16_eq_inst0 (
    .in0(magma_UInt_17_add_inst1_out[15:0]),
    .in1(const_0_16_out),
    .out(magma_UInt_16_eq_inst0_out)
);
wire [16:0] magma_UInt_17_add_inst0_in0;
assign magma_UInt_17_add_inst0_in0 = {bit_const_0_None_out,a[15:0]};
wire [16:0] magma_UInt_17_add_inst0_in1;
assign magma_UInt_17_add_inst0_in1 = {bit_const_0_None_out,b[15:0]};
coreir_add #(
    .width(17)
) magma_UInt_17_add_inst0 (
    .in0(magma_UInt_17_add_inst0_in0),
    .in1(magma_UInt_17_add_inst0_in1),
    .out(magma_UInt_17_add_inst0_out)
);
coreir_add #(
    .width(17)
) magma_UInt_17_add_inst1 (
    .in0(magma_UInt_17_add_inst0_out),
    .in1(const_0_17_out),
    .out(magma_UInt_17_add_inst1_out)
);
assign O0 = magma_UInt_17_add_inst1_out[15:0];
assign O1 = magma_UInt_17_add_inst1_out[16];
assign O2 = magma_UInt_16_eq_inst0_out;
assign O3 = magma_UInt_17_add_inst1_out[15];
assign O4 = magma_UInt_17_add_inst1_out[16];
assign O5 = magma_Bit_or_inst0_out;
endmodule

module PE_gen (
    input [48:0] inst,
    input [47:0] inputs,
    input clk_en,
    output [16:0] O,
    input CLK,
    input ASYNCRESET
);
wire [15:0] ADD_inst0_O0;
wire ADD_inst0_O1;
wire ADD_inst0_O2;
wire ADD_inst0_O3;
wire ADD_inst0_O4;
wire ADD_inst0_O5;
wire [15:0] ADD_inst1_O0;
wire ADD_inst1_O1;
wire ADD_inst1_O2;
wire ADD_inst1_O3;
wire ADD_inst1_O4;
wire ADD_inst1_O5;
wire Cond_inst0_O;
wire Cond_inst1_O;
wire Cond_inst2_O;
wire [15:0] GTE_inst0_O0;
wire GTE_inst0_O1;
wire GTE_inst0_O2;
wire GTE_inst0_O3;
wire GTE_inst0_O4;
wire GTE_inst0_O5;
wire [15:0] LTE_inst0_O0;
wire LTE_inst0_O1;
wire LTE_inst0_O2;
wire LTE_inst0_O3;
wire LTE_inst0_O4;
wire LTE_inst0_O5;
wire [15:0] MUL_inst0_O;
wire Mux2xBit_inst0_O;
wire Mux2xBit_inst1_O;
wire [15:0] Mux2xBits16_inst0_O;
wire [15:0] Mux2xBits16_inst1_O;
wire [15:0] Mux2xBits16_inst10_O;
wire [15:0] Mux2xBits16_inst11_O;
wire [15:0] Mux2xBits16_inst12_O;
wire [15:0] Mux2xBits16_inst13_O;
wire [15:0] Mux2xBits16_inst14_O;
wire [15:0] Mux2xBits16_inst15_O;
wire [15:0] Mux2xBits16_inst16_O;
wire [15:0] Mux2xBits16_inst17_O;
wire [15:0] Mux2xBits16_inst18_O;
wire [15:0] Mux2xBits16_inst19_O;
wire [15:0] Mux2xBits16_inst2_O;
wire [15:0] Mux2xBits16_inst3_O;
wire [15:0] Mux2xBits16_inst4_O;
wire [15:0] Mux2xBits16_inst5_O;
wire [15:0] Mux2xBits16_inst6_O;
wire [15:0] Mux2xBits16_inst7_O;
wire [15:0] Mux2xBits16_inst8_O;
wire [15:0] Mux2xBits16_inst9_O;
wire [15:0] SHR_inst0_O0;
wire SHR_inst0_O1;
wire SHR_inst0_O2;
wire SHR_inst0_O3;
wire SHR_inst0_O4;
wire SHR_inst0_O5;
wire [15:0] SUB_inst0_O0;
wire SUB_inst0_O1;
wire SUB_inst0_O2;
wire SUB_inst0_O3;
wire SUB_inst0_O4;
wire SUB_inst0_O5;
wire [0:0] const_0_1_out;
wire [1:0] const_0_2_out;
wire [2:0] const_0_3_out;
wire [0:0] const_1_1_out;
wire [1:0] const_1_2_out;
wire [2:0] const_1_3_out;
wire [1:0] const_2_2_out;
wire [2:0] const_2_3_out;
wire [2:0] const_3_3_out;
wire [2:0] const_4_3_out;
wire [2:0] const_5_3_out;
wire [2:0] const_6_3_out;
wire magma_Bits_1_eq_inst0_out;
wire magma_Bits_1_eq_inst1_out;
wire magma_Bits_1_eq_inst10_out;
wire magma_Bits_1_eq_inst11_out;
wire magma_Bits_1_eq_inst2_out;
wire magma_Bits_1_eq_inst3_out;
wire magma_Bits_1_eq_inst4_out;
wire magma_Bits_1_eq_inst5_out;
wire magma_Bits_1_eq_inst6_out;
wire magma_Bits_1_eq_inst7_out;
wire magma_Bits_1_eq_inst8_out;
wire magma_Bits_1_eq_inst9_out;
wire magma_Bits_2_eq_inst0_out;
wire magma_Bits_2_eq_inst1_out;
wire magma_Bits_2_eq_inst2_out;
wire magma_Bits_3_eq_inst0_out;
wire magma_Bits_3_eq_inst1_out;
wire magma_Bits_3_eq_inst2_out;
wire magma_Bits_3_eq_inst3_out;
wire magma_Bits_3_eq_inst4_out;
wire magma_Bits_3_eq_inst5_out;
wire magma_Bits_3_eq_inst6_out;
ADD ADD_inst0 (
    .a(inputs[47:32]),
    .b(inputs[15:0]),
    .O0(ADD_inst0_O0),
    .O1(ADD_inst0_O1),
    .O2(ADD_inst0_O2),
    .O3(ADD_inst0_O3),
    .O4(ADD_inst0_O4),
    .O5(ADD_inst0_O5),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
ADD ADD_inst1 (
    .a(inputs[31:16]),
    .b(Mux2xBits16_inst4_O),
    .O0(ADD_inst1_O0),
    .O1(ADD_inst1_O1),
    .O2(ADD_inst1_O2),
    .O3(ADD_inst1_O3),
    .O4(ADD_inst1_O4),
    .O5(ADD_inst1_O5),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
Cond Cond_inst0 (
    .code(inst[4:0]),
    .alu(GTE_inst0_O1),
    .Z(GTE_inst0_O2),
    .N(GTE_inst0_O3),
    .C(GTE_inst0_O4),
    .V(GTE_inst0_O5),
    .O(Cond_inst0_O),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
Cond Cond_inst1 (
    .code(inst[9:5]),
    .alu(LTE_inst0_O1),
    .Z(LTE_inst0_O2),
    .N(LTE_inst0_O3),
    .C(LTE_inst0_O4),
    .V(LTE_inst0_O5),
    .O(Cond_inst1_O),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
Cond Cond_inst2 (
    .code(inst[14:10]),
    .alu(SUB_inst0_O1),
    .Z(SUB_inst0_O2),
    .N(SUB_inst0_O3),
    .C(SUB_inst0_O4),
    .V(SUB_inst0_O5),
    .O(Cond_inst2_O),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
GTE GTE_inst0 (
    .signed_(inst[46]),
    .a(inputs[47:32]),
    .b(Mux2xBits16_inst6_O),
    .O0(GTE_inst0_O0),
    .O1(GTE_inst0_O1),
    .O2(GTE_inst0_O2),
    .O3(GTE_inst0_O3),
    .O4(GTE_inst0_O4),
    .O5(GTE_inst0_O5),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
LTE LTE_inst0 (
    .signed_(inst[47]),
    .a(inputs[47:32]),
    .b(Mux2xBits16_inst8_O),
    .O0(LTE_inst0_O0),
    .O1(LTE_inst0_O1),
    .O2(LTE_inst0_O2),
    .O3(LTE_inst0_O3),
    .O4(LTE_inst0_O4),
    .O5(LTE_inst0_O5),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
MUL MUL_inst0 (
    .instr(inst[16:15]),
    .signed_(inst[45]),
    .a(inputs[47:32]),
    .b(Mux2xBits16_inst1_O),
    .O(MUL_inst0_O),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
Mux2xBit Mux2xBit_inst0 (
    .I0(Cond_inst0_O),
    .I1(Cond_inst0_O),
    .S(magma_Bits_1_eq_inst10_out),
    .O(Mux2xBit_inst0_O)
);
Mux2xBit Mux2xBit_inst1 (
    .I0(Mux2xBit_inst0_O),
    .I1(inst[33]),
    .S(magma_Bits_1_eq_inst11_out),
    .O(Mux2xBit_inst1_O)
);
Mux2xBits16 Mux2xBits16_inst0 (
    .I0(inst[32:17]),
    .I1(inst[32:17]),
    .S(magma_Bits_1_eq_inst0_out),
    .O(Mux2xBits16_inst0_O)
);
Mux2xBits16 Mux2xBits16_inst1 (
    .I0(Mux2xBits16_inst0_O),
    .I1(inputs[15:0]),
    .S(magma_Bits_1_eq_inst1_out),
    .O(Mux2xBits16_inst1_O)
);
Mux2xBits16 Mux2xBits16_inst10 (
    .I0(Mux2xBits16_inst9_O),
    .I1(inputs[15:0]),
    .S(magma_Bits_1_eq_inst7_out),
    .O(Mux2xBits16_inst10_O)
);
Mux2xBits16 Mux2xBits16_inst11 (
    .I0(inst[32:17]),
    .I1(inst[32:17]),
    .S(magma_Bits_1_eq_inst8_out),
    .O(Mux2xBits16_inst11_O)
);
Mux2xBits16 Mux2xBits16_inst12 (
    .I0(Mux2xBits16_inst11_O),
    .I1(inputs[15:0]),
    .S(magma_Bits_1_eq_inst9_out),
    .O(Mux2xBits16_inst12_O)
);
Mux2xBits16 Mux2xBits16_inst13 (
    .I0(ADD_inst1_O0),
    .I1(ADD_inst1_O0),
    .S(magma_Bits_3_eq_inst0_out),
    .O(Mux2xBits16_inst13_O)
);
Mux2xBits16 Mux2xBits16_inst14 (
    .I0(Mux2xBits16_inst13_O),
    .I1(GTE_inst0_O0),
    .S(magma_Bits_3_eq_inst1_out),
    .O(Mux2xBits16_inst14_O)
);
Mux2xBits16 Mux2xBits16_inst15 (
    .I0(Mux2xBits16_inst14_O),
    .I1(SHR_inst0_O0),
    .S(magma_Bits_3_eq_inst2_out),
    .O(Mux2xBits16_inst15_O)
);
Mux2xBits16 Mux2xBits16_inst16 (
    .I0(Mux2xBits16_inst15_O),
    .I1(inst[32:17]),
    .S(magma_Bits_3_eq_inst3_out),
    .O(Mux2xBits16_inst16_O)
);
Mux2xBits16 Mux2xBits16_inst17 (
    .I0(Mux2xBits16_inst16_O),
    .I1(MUL_inst0_O),
    .S(magma_Bits_3_eq_inst4_out),
    .O(Mux2xBits16_inst17_O)
);
Mux2xBits16 Mux2xBits16_inst18 (
    .I0(Mux2xBits16_inst17_O),
    .I1(SUB_inst0_O0),
    .S(magma_Bits_3_eq_inst5_out),
    .O(Mux2xBits16_inst18_O)
);
Mux2xBits16 Mux2xBits16_inst19 (
    .I0(Mux2xBits16_inst18_O),
    .I1(LTE_inst0_O0),
    .S(magma_Bits_3_eq_inst6_out),
    .O(Mux2xBits16_inst19_O)
);
Mux2xBits16 Mux2xBits16_inst2 (
    .I0(inst[32:17]),
    .I1(inst[32:17]),
    .S(magma_Bits_2_eq_inst0_out),
    .O(Mux2xBits16_inst2_O)
);
Mux2xBits16 Mux2xBits16_inst3 (
    .I0(Mux2xBits16_inst2_O),
    .I1(inputs[47:32]),
    .S(magma_Bits_2_eq_inst1_out),
    .O(Mux2xBits16_inst3_O)
);
Mux2xBits16 Mux2xBits16_inst4 (
    .I0(Mux2xBits16_inst3_O),
    .I1(ADD_inst0_O0),
    .S(magma_Bits_2_eq_inst2_out),
    .O(Mux2xBits16_inst4_O)
);
Mux2xBits16 Mux2xBits16_inst5 (
    .I0(inst[32:17]),
    .I1(inst[32:17]),
    .S(magma_Bits_1_eq_inst2_out),
    .O(Mux2xBits16_inst5_O)
);
Mux2xBits16 Mux2xBits16_inst6 (
    .I0(Mux2xBits16_inst5_O),
    .I1(inputs[15:0]),
    .S(magma_Bits_1_eq_inst3_out),
    .O(Mux2xBits16_inst6_O)
);
Mux2xBits16 Mux2xBits16_inst7 (
    .I0(inst[32:17]),
    .I1(inst[32:17]),
    .S(magma_Bits_1_eq_inst4_out),
    .O(Mux2xBits16_inst7_O)
);
Mux2xBits16 Mux2xBits16_inst8 (
    .I0(Mux2xBits16_inst7_O),
    .I1(inputs[15:0]),
    .S(magma_Bits_1_eq_inst5_out),
    .O(Mux2xBits16_inst8_O)
);
Mux2xBits16 Mux2xBits16_inst9 (
    .I0(inst[32:17]),
    .I1(inst[32:17]),
    .S(magma_Bits_1_eq_inst6_out),
    .O(Mux2xBits16_inst9_O)
);
SHR SHR_inst0 (
    .signed_(inst[48]),
    .a(inputs[47:32]),
    .b(Mux2xBits16_inst12_O),
    .O0(SHR_inst0_O0),
    .O1(SHR_inst0_O1),
    .O2(SHR_inst0_O2),
    .O3(SHR_inst0_O3),
    .O4(SHR_inst0_O4),
    .O5(SHR_inst0_O5),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
SUB SUB_inst0 (
    .a(inputs[47:32]),
    .b(Mux2xBits16_inst10_O),
    .O0(SUB_inst0_O0),
    .O1(SUB_inst0_O1),
    .O2(SUB_inst0_O2),
    .O3(SUB_inst0_O3),
    .O4(SUB_inst0_O4),
    .O5(SUB_inst0_O5),
    .CLK(CLK),
    .ASYNCRESET(ASYNCRESET)
);
coreir_const #(
    .value(1'h0),
    .width(1)
) const_0_1 (
    .out(const_0_1_out)
);
coreir_const #(
    .value(2'h0),
    .width(2)
) const_0_2 (
    .out(const_0_2_out)
);
coreir_const #(
    .value(3'h0),
    .width(3)
) const_0_3 (
    .out(const_0_3_out)
);
coreir_const #(
    .value(1'h1),
    .width(1)
) const_1_1 (
    .out(const_1_1_out)
);
coreir_const #(
    .value(2'h1),
    .width(2)
) const_1_2 (
    .out(const_1_2_out)
);
coreir_const #(
    .value(3'h1),
    .width(3)
) const_1_3 (
    .out(const_1_3_out)
);
coreir_const #(
    .value(2'h2),
    .width(2)
) const_2_2 (
    .out(const_2_2_out)
);
coreir_const #(
    .value(3'h2),
    .width(3)
) const_2_3 (
    .out(const_2_3_out)
);
coreir_const #(
    .value(3'h3),
    .width(3)
) const_3_3 (
    .out(const_3_3_out)
);
coreir_const #(
    .value(3'h4),
    .width(3)
) const_4_3 (
    .out(const_4_3_out)
);
coreir_const #(
    .value(3'h5),
    .width(3)
) const_5_3 (
    .out(const_5_3_out)
);
coreir_const #(
    .value(3'h6),
    .width(3)
) const_6_3 (
    .out(const_6_3_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst0 (
    .in0(inst[34]),
    .in1(const_0_1_out),
    .out(magma_Bits_1_eq_inst0_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst1 (
    .in0(inst[34]),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst1_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst10 (
    .in0(inst[44]),
    .in1(const_0_1_out),
    .out(magma_Bits_1_eq_inst10_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst11 (
    .in0(inst[44]),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst11_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst2 (
    .in0(inst[37]),
    .in1(const_0_1_out),
    .out(magma_Bits_1_eq_inst2_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst3 (
    .in0(inst[37]),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst3_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst4 (
    .in0(inst[38]),
    .in1(const_0_1_out),
    .out(magma_Bits_1_eq_inst4_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst5 (
    .in0(inst[38]),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst5_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst6 (
    .in0(inst[39]),
    .in1(const_0_1_out),
    .out(magma_Bits_1_eq_inst6_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst7 (
    .in0(inst[39]),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst7_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst8 (
    .in0(inst[40]),
    .in1(const_0_1_out),
    .out(magma_Bits_1_eq_inst8_out)
);
coreir_eq #(
    .width(1)
) magma_Bits_1_eq_inst9 (
    .in0(inst[40]),
    .in1(const_1_1_out),
    .out(magma_Bits_1_eq_inst9_out)
);
coreir_eq #(
    .width(2)
) magma_Bits_2_eq_inst0 (
    .in0(inst[36:35]),
    .in1(const_0_2_out),
    .out(magma_Bits_2_eq_inst0_out)
);
coreir_eq #(
    .width(2)
) magma_Bits_2_eq_inst1 (
    .in0(inst[36:35]),
    .in1(const_1_2_out),
    .out(magma_Bits_2_eq_inst1_out)
);
coreir_eq #(
    .width(2)
) magma_Bits_2_eq_inst2 (
    .in0(inst[36:35]),
    .in1(const_2_2_out),
    .out(magma_Bits_2_eq_inst2_out)
);
coreir_eq #(
    .width(3)
) magma_Bits_3_eq_inst0 (
    .in0(inst[43:41]),
    .in1(const_0_3_out),
    .out(magma_Bits_3_eq_inst0_out)
);
coreir_eq #(
    .width(3)
) magma_Bits_3_eq_inst1 (
    .in0(inst[43:41]),
    .in1(const_1_3_out),
    .out(magma_Bits_3_eq_inst1_out)
);
coreir_eq #(
    .width(3)
) magma_Bits_3_eq_inst2 (
    .in0(inst[43:41]),
    .in1(const_2_3_out),
    .out(magma_Bits_3_eq_inst2_out)
);
coreir_eq #(
    .width(3)
) magma_Bits_3_eq_inst3 (
    .in0(inst[43:41]),
    .in1(const_3_3_out),
    .out(magma_Bits_3_eq_inst3_out)
);
coreir_eq #(
    .width(3)
) magma_Bits_3_eq_inst4 (
    .in0(inst[43:41]),
    .in1(const_4_3_out),
    .out(magma_Bits_3_eq_inst4_out)
);
coreir_eq #(
    .width(3)
) magma_Bits_3_eq_inst5 (
    .in0(inst[43:41]),
    .in1(const_5_3_out),
    .out(magma_Bits_3_eq_inst5_out)
);
coreir_eq #(
    .width(3)
) magma_Bits_3_eq_inst6 (
    .in0(inst[43:41]),
    .in1(const_6_3_out),
    .out(magma_Bits_3_eq_inst6_out)
);
assign O = {Mux2xBit_inst1_O,Mux2xBits16_inst19_O[15:0]};
endmodule

