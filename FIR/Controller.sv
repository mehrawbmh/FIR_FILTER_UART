`define Idle 2'b00
`define Cal 2'b01
`define Wait 2'b10
`define Ready 2'b11

module Controller #(parameter WIDTH = 16 , LENGTH = 64 , COUNTER_BIT = 5)(
	input clk,
	input rst,
	input valid_Input,
	output reg Shift_en,
	output reg ResReg_en,
	output reg flush,
	output reg Output_valid,
    output [COUNTER_BIT : 0] cnt
);

	/*sequence s1;
		(flush ##1 ResReg_en);
	endsequence

	property p1;
		@(posedge clk) valid_Input |-> s1;
	endproperty

	Flushing: assert property (p1) $display($stime,,,"\t\t %m Pass : flushing is correct");
	else $error($stime,,,"\t\t %m FAIL : flushing is incorrect");*/
	/*
	parameter g = LENGTH + 1;
	sequence s2;
		(valid_Input ##g Output_valid);
	endsequence

	property p2;
		@(posedge clk) valid_Input |-> s2;
	endproperty

	Calcultion: assert property (p2) $display($stime,,,"\t\t %m Pass : Calculation time is correct");
	else $error($stime,,,"\t\t %m FAIL : Calculation time is incorrect");*/

	/*parameter f = LENGTH - 1 ;
	property p3;
	@(posedge clk) $rose(CE) |-> ##f $rose(CO);
	endproperty

	counting: assert property (p3) $display($stime,,,"\t\t %m Pass : Counting is correct");
	else $error($stime,,,"\t\t %m FAIL : Counting is incorrect");*/

    wire CO;
    reg CE;
	reg[1:0] ns , ps;

    Counter #(.size(COUNTER_BIT + 1) , .LENGTH(LENGTH)) counter (
		.clk(clk),
		.rst(rst), 
		.flush(flush), 
		.CE(CE), 
		.CO(CO), 
		.cnt(cnt)
	);

	always @(ps,valid_Input,CO) begin
		ns <= `Idle;
		case (ps)
			`Idle: begin 
				ns <= valid_Input ? `Cal : `Idle;
			end
			`Cal: begin
				ns <= CO ? `Ready : `Cal;
			end
			`Wait: begin 
				ns <= `Wait;
			end
			`Ready:begin 
				ns <= `Idle;
			end
			default:
				ns <= `Idle;
		endcase
	end

	always @(ps , valid_Input) begin
		{Shift_en, ResReg_en , flush, Output_valid, CE} <= 0;
		case (ps)
			`Idle : begin
				Shift_en <= valid_Input;
				flush <= 1'b1;
			end
			`Cal : begin
                ResReg_en <= 1'b1;
				CE <= 1'b1;
			end
			`Wait : begin
			end
			`Ready:begin 
				Output_valid <= 1'b1;
			end
			default: begin
				Shift_en <= 1'b0;
				ResReg_en <= 1'b0;
				flush <= 1'b0;
				Output_valid <= 1'b0;
				CE <= 1'b0;
				end
		endcase
	end

	always @(posedge clk,posedge rst) begin
		if(rst)
			ps <= `Idle;
		else
			ps <= ns;
	end

endmodule
