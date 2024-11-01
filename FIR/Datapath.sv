module Datapath #(parameter WIDTH = 16 , LENGTH = 64, COUNTER_BIT = 5)(
	input clk,
	input rst,
	input [WIDTH - 1 : 0] FIR_input,
    input [COUNTER_BIT : 0] cnt,
    input Shift_en,
    input ResReg_en,
    input flush,
	output [2*WIDTH + $clog2(LENGTH) - 1 : 0] FIR_output
);
    wire signed [WIDTH - 1:0] coeff;
    wire signed [WIDTH - 1:0] data_in;
    wire signed [2 * WIDTH -1 : 0] mult_res;
    wire signed [2*WIDTH + $clog2(LENGTH) - 1 : 0] result;

    ShiftReg_2D #(.LENGTH(LENGTH) , .WIDTH(WIDTH) , .COUNTER_BIT(COUNTER_BIT)) shift_reg2d(
    .clk(clk), 
    .rst(rst), 
    .shift(Shift_en),
    .address(cnt),
    .FIR_input(FIR_input), 
    .output_shift_reg(data_in)
    );

	Coeff_mem #(.LENGTH(LENGTH) , .WIDTH(WIDTH) , .COUNTER_BIT(COUNTER_BIT)) coefff_mem(
    .address(cnt), 
    .clk(clk), 
    .coeff(coeff)
    );

	Multiplier #(.WIDTH(WIDTH)) mult (
    .a(data_in), 
    .b(coeff), 
    .s(mult_res)
    );

	Register #(.size(2*WIDTH + $clog2(LENGTH))) resreg(
    .clk(clk), 
    .rst(rst) ,
    .LE(ResReg_en), 
    .flush(flush), 
    .SerIn(result), 
    .data_out(FIR_output)
    );

	Adder #(.WIDTH1(2*WIDTH) , .WIDTH2(2*WIDTH + $clog2(LENGTH))) adder(
    .a(mult_res), 
    .b(FIR_output), 
    .s(result)
    );
	
	
endmodule
