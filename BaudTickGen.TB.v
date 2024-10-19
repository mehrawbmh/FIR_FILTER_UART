`timescale 1ns/1ns
module BaudTickGenTB();
    reg enable, clk;
    wire tick;

    initial begin
        clk = 1'b0;
        enable = 1'b0;
    end

    always #10 clk = ~clk; //50MHz

    BaudTickGen bb(clk, enable, tick);

    initial begin
        #50
        enable = 1'b1;
        #20000
        enable = 1'b0;
	#100
	enable = 1'b1;
        #10000
        $stop;
    end


endmodule
