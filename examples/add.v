parameter WIDTH=16;

module coreir_op #(
    parameter width = 16
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    output [width-1:0] out
);
  assign out = in0 + in1;
endmodule

module coreir_reg #(
    parameter width = 1,
    parameter clk_posedge = 1,
    parameter init = 1
) (
    input clk,
    input [width-1:0] in,
    output [width-1:0] out
);
  reg [width-1:0] outReg=init;
  wire real_clk;
  assign real_clk = clk_posedge ? clk : ~clk;
  always @(posedge real_clk) begin
    outReg <= in;
  end
  assign out = outReg;
endmodule


module add (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    input clk
);

    wire [WIDTH-1:0] a_reg;

    coreir_reg #(
        .clk_posedge(1'b1),
        .init(1'h0),
        .width(WIDTH)
    ) reg_a (
        .clk(clk),
        .in(a),
        .out(a_reg)
    );

    wire [WIDTH-1:0] b_reg;

    coreir_reg #(
        .clk_posedge(1'b1),
        .init(1'h0),
        .width(WIDTH)
    ) reg_b (
        .clk(clk),
        .in(b),
        .out(b_reg)
    );

    coreir_op #(
        .width(WIDTH)
    ) adder (a_reg,b_reg,out_reg);


    wire [WIDTH-1:0] out_reg;

    coreir_reg #(
        .clk_posedge(1'b1),
        .init(1'h0),
        .width(WIDTH)
    ) reg_in (
        .clk(clk),
        .in(out_reg),
        .out(out)
    );

endmodule