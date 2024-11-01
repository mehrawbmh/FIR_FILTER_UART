module Coeff_mem #(parameter WIDTH = 16 , LENGTH = 64 , COUNTER_BIT = 5) (
	input [COUNTER_BIT : 0] address,
	input clk,
	output [WIDTH - 1:0] coeff
);

	reg [WIDTH - 1:0] coeffs [0:LENGTH-1];

	initial
	begin
		$readmemb("coeffs.txt",coeffs);
	end
	
	//(* romstyle = "M4K" *) (* ram_init_file = "coeff.mif" *) reg [WIDTH - 1:0] coeffs [0:LENGTH-1];

    assign coeff = coeffs[address];

endmodule