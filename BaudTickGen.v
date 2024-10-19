module BaudTickGen(
    input clk, enable,
    output reg tick
);
parameter ClkFrequency = 50000000;
parameter Baud = 115200;
parameter Oversampling = 1;

    localparam divideCount = ClkFrequency / (Baud * Oversampling); //434
    localparam len = $clog2(divideCount);

    reg[len-1 : 0] count;

    always @(posedge clk) begin
        if (enable) 
            count <= count + 1;
        else
            count <= {(len){1'b0}};

        if (count == divideCount) begin
            tick <= 1'b1;
	        count <= {(len){1'b0}};
	    end
        else
            tick <= 1'b0;

    end

endmodule
