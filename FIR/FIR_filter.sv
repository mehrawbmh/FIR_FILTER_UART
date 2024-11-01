module FIR #(parameter WIDTH = 16 , LENGTH = 64 , COUNTER_BIT = 5, WIDTH_o = 38)(
	input clk,
	input reset,
	input input_valid,
	input signed [WIDTH - 1 : 0] FIR_input,
	output output_valid,
    output signed [WIDTH_o - 1 : 0] FIR_output
);

wire Shift_en, ResReg_en, flush;
wire [COUNTER_BIT : 0] cnt;

Datapath #(.LENGTH(LENGTH) , .WIDTH(WIDTH), .COUNTER_BIT(COUNTER_BIT))dp(
.clk(clk), 
.rst(reset), 
.FIR_input(FIR_input), 
.cnt(cnt),
.Shift_en(Shift_en), 
.ResReg_en(ResReg_en), 
.flush(flush), 
.FIR_output(FIR_output)
);

Controller #(.LENGTH(LENGTH) ,.WIDTH(WIDTH), .COUNTER_BIT(COUNTER_BIT))controller(
.clk(clk), 
.rst(reset), 
.valid_Input(input_valid), 
.Shift_en(Shift_en), 
.ResReg_en(ResReg_en),
.flush(flush), 
.Output_valid(output_valid), 
.cnt(cnt)
);

endmodule
