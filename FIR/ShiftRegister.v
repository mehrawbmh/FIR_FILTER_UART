module RightShiftRegister #(parameter WIDTH = 8)(
    input clk,
    input rst,
    input serIn,
    input shiftEn,
    input parLd,
    input [WIDTH-1:0] parIn,
    output reg [WIDTH-1:0] parOut,
    output  serOut
);

always @(posedge clk, posedge rst)begin
    if(rst)
        parOut <= 0;
    else if(shiftEn)
        parOut <= {serIn,parOut[WIDTH-1:1]};
    else if(parLd)
        parOut <= parIn;
    else
        parOut <= parOut;


end
assign serOut = parOut[0];
endmodule