module Multiplier #(parameter WIDTH = 64)(
    input signed [WIDTH - 1 : 0] a,
    input signed [WIDTH - 1 : 0] b,
    output signed [2 * WIDTH -1 : 0] s
);
assign s = a * b;
endmodule
