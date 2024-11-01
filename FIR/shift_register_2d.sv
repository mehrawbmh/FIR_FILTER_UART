module ShiftReg_2D #(parameter LENGTH = 64, WIDTH = 16, COUNTER_BIT = 5)(
    input clk,
    input rst,
    input shift,
    input [COUNTER_BIT : 0] address,
    input [WIDTH - 1:0] FIR_input,
    output signed [WIDTH - 1:0] output_shift_reg
);
    reg [WIDTH - 1:0] inputs_shift_regs [0:LENGTH-1];
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            integer i;
            for(i = 0 ; i < LENGTH ; i = i + 1)
                inputs_shift_regs[i] <= {(WIDTH){1'b0}};
        end

        else if (shift) begin
            integer i;
            inputs_shift_regs[0] <= FIR_input;
            for(i = 0 ; i < LENGTH - 1 ; i = i + 1)
                inputs_shift_regs[i+1] <= inputs_shift_regs[i];
        end

        else begin
            integer i;
            for(i = 0 ; i < LENGTH ; i = i + 1)
                inputs_shift_regs[i] <= inputs_shift_regs[i];
        end
    end

    assign output_shift_reg = inputs_shift_regs[address];

endmodule
