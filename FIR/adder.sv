module Adder #(parameter WIDTH1 = 32 , WIDTH2 = 38)(
    input signed [WIDTH1-1:0] a,
    input signed [WIDTH2-1:0] b,
    output signed [WIDTH2-1:0] s);

assign s = a+b;

endmodule

