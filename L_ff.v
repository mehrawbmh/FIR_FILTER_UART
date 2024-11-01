module Left_FF (
    input clk,
    input load1,
    input load2,
    input [7:0] in,
    output reg [15:0] out
);

    always @(posedge clk) begin
        if(load1)
            out <= {in, out[7:0]};
        else if(load2)
            out <= {out[15:8], in};
        else
            out <= out;
    end

    
endmodule