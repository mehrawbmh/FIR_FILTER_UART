module Right_FF (
    input clk,
    input load,
    input mode,
    input [37:0] in,
    output [7:0] out
);
    reg [37:0] my_reg;
    always @(posedge clk) begin
        if(load)
            my_reg <= in;
        else
            my_reg = my_reg;
    end

    assign out = (mode == 1'b0) ? my_reg[27:20] : my_reg[19:12];

endmodule