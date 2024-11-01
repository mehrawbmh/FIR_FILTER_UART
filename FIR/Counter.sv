module Counter #(parameter size = 6 , LENGTH = 64)(
	input clk,
	input rst,
	input CE,
	input flush,
	output CO,
    output reg [size -1 : 0] cnt
);
	always @(posedge clk , posedge rst) begin
		if(rst)
			cnt <= {(size){1'b0}};
		else if (flush)
			cnt <= {(size){1'b0}};
		else if (CE)
			cnt <= cnt + 1;
		else 
			cnt <= cnt;
	end
	
	assign CO = &cnt;
	
endmodule
