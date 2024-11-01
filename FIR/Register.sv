module Register #(parameter size = 2)(
	input clk,
	input rst,
	input LE,
    input flush,
	input [size -1 : 0] SerIn,
	output reg [size -1 : 0] data_out
);

	always @(posedge clk , posedge rst) begin
		if(rst)
			data_out <= {(size){1'b0}};
        else if(flush)
            data_out <= {(size){1'b0}};
		else if (LE)
			data_out <= SerIn;
		else
			data_out <= data_out;
	end
	
endmodule
